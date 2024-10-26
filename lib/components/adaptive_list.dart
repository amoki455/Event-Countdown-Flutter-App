import 'dart:ui';
import 'package:flutter/material.dart';

class AdaptiveList extends StatefulWidget {
  const AdaptiveList({
    super.key,
    required this.gridItemWidth,
    required this.gridItemHeight,
    required this.itemCount,
    required this.itemBuilder,
    required this.itemKey,
    this.listPadding,
    this.gridTopPadding = 0,
    this.gridBottomPadding = 0,
    required this.removeExecutor,
  });

  final double gridItemWidth;
  final double gridItemHeight;
  final int itemCount;
  final NullableIndexedWidgetBuilder itemBuilder;
  final Object Function(int index) itemKey;
  final EdgeInsetsGeometry? listPadding;
  final double gridTopPadding;
  final double gridBottomPadding;
  final ListItemRemoveExecutor removeExecutor;

  @override
  State<AdaptiveList> createState() => _AdaptiveListState();
}

class _AdaptiveListState extends State<AdaptiveList> {
  final Map<Object, int> _items = {};
  final Map<Object, _ItemRemovalCallback> _itemsRemovalCallbacks = {};

  @override
  void initState() {
    super.initState();
    widget.removeExecutor.run = _executeItemRemoval;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = constraints.maxWidth ~/ widget.gridItemWidth;
        if (columnCount > 1) {
          final columnWidth = constraints.maxWidth / columnCount;
          return buildGrid(columnCount, columnWidth);
        } else {
          return buildList();
        }
      },
    );
  }

  Widget buildList() {
    return Align(
      alignment: Alignment.topCenter,
      child: ListView.builder(
        padding: widget.listPadding ?? const EdgeInsets.all(4),
        shrinkWrap: true,
        itemCount: widget.itemCount,
        itemBuilder: (context, index) {
          return _AnimatedItem(
            key: ObjectKey(widget.itemKey(index)),
            index: index,
            oldIndex: _getOldIndex(widget.itemKey(index), index),
            itemRemovalCallback: _getItemRemovalCallback(widget.itemKey(index)),
            child: widget.itemBuilder(context, index) ?? const SizedBox(),
          );
        },
      ),
    );
  }

  Widget buildGrid(int columnCount, double columnWidth) {
    final double extraHorizontalSpace = columnWidth > widget.gridItemWidth ? (columnWidth - widget.gridItemWidth) * columnCount : 6;

    final double horizontalSpacing = extraHorizontalSpace / (2 + (columnCount - 1));
    final itemHorizontalSpacing = horizontalSpacing / 3;
    double gridHorizontalPadding = horizontalSpacing + ((horizontalSpacing - itemHorizontalSpacing) / 2) * (columnCount - 1);
    double verticalSpacing = horizontalSpacing / 4;

    return Align(
      alignment: Alignment.topCenter,
      child: GridView.builder(
        padding: EdgeInsets.only(
          left: gridHorizontalPadding,
          right: gridHorizontalPadding,
          top: verticalSpacing + widget.gridTopPadding,
          bottom: verticalSpacing + widget.gridBottomPadding,
        ),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount,
          crossAxisSpacing: itemHorizontalSpacing,
          mainAxisSpacing: verticalSpacing,
          childAspectRatio: widget.gridItemWidth / widget.gridItemHeight,
        ),
        itemCount: widget.itemCount,
        itemBuilder: (context, index) {
          return _AnimatedItem(
            key: ObjectKey(widget.itemKey(index)),
            index: index,
            oldIndex: _getOldIndex(widget.itemKey(index), index),
            itemRemovalCallback: _getItemRemovalCallback(widget.itemKey(index)),
            isInGrid: true,
            gridColumnCount: columnCount,
            singleGridItemXOffset: widget.gridItemWidth + itemHorizontalSpacing,
            singleGridItemYOffset: widget.gridItemHeight + verticalSpacing,
            child: widget.itemBuilder(context, index) ?? const SizedBox(),
          );
        },
      ),
    );
  }

  int _getOldIndex(Object itemKey, int newIndex) {
    final old = _items[itemKey] ?? -1;
    _items[itemKey] = newIndex;
    return old;
  }

  _ItemRemovalCallback _getItemRemovalCallback(Object itemKey) {
    final old = _itemsRemovalCallbacks[itemKey];
    if (old != null) return old;
    final newValue = _ItemRemovalCallback();
    _itemsRemovalCallbacks[itemKey] = newValue;
    return newValue;
  }

  void _executeItemRemoval(Object itemKey, VoidCallback fn) {
    final callback = _itemsRemovalCallbacks[itemKey];
    if (callback != null && callback.run != null) {
      callback.run!().then((_) => fn());
    }
    // _itemsRemovalCallbacks.remove(itemKey);
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _AnimatedItem extends StatefulWidget {
  const _AnimatedItem({
    super.key,
    required this.child,
    required this.index,
    required this.oldIndex,
    this.singleGridItemXOffset = 0,
    this.singleGridItemYOffset = 0,
    this.isInGrid = false,
    this.gridColumnCount = 0,
    required this.itemRemovalCallback,
  });

  final bool isInGrid;
  final int gridColumnCount;
  final Widget child;
  final int index;
  final int oldIndex;
  final double singleGridItemXOffset;
  final double singleGridItemYOffset;
  final _ItemRemovalCallback itemRemovalCallback;

  @override
  State<_AnimatedItem> createState() => _AnimatedItemState();
}

class _AnimatedItemState extends State<_AnimatedItem> with SingleTickerProviderStateMixin {
  late final AnimationController _animationCtrl;
  late final CurvedAnimation _curvedAnimation;
  Animation<Offset>? _gridItemOffsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )
      ..addListener(_animationListener)
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _gridItemOffsetAnimation = null;
          }
        },
      );

    _curvedAnimation = CurvedAnimation(
      parent: _animationCtrl,
      curve: Curves.fastEaseInToSlowEaseOut,
    );

    widget.itemRemovalCallback.run = () async {
      if (mounted) {
        await _animationCtrl.reverse();
      }
    };

    _checkItemReordering();

    if ((widget.isInGrid && _gridItemOffsetAnimation != null)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _animationCtrl.forward(from: 0);
        }
      });
    } else if (widget.oldIndex == -1) {
      _animationCtrl.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isInGrid && _gridItemOffsetAnimation != null) {
      return _buildGridReorderingView();
    }

    switch (_animationCtrl.status) {
      case AnimationStatus.reverse:
        return _buildDisappearingView();
      case AnimationStatus.dismissed:
        _animationCtrl.value = 1;
        return _buildAppearingView();
      case AnimationStatus.forward:
      case AnimationStatus.completed:
        return _buildAppearingView();
    }
  }

  Widget _buildAppearingView() {
    return Opacity(
      opacity: _curvedAnimation.value,
      child: Transform.scale(
        alignment: Alignment.topCenter,
        scale: lerpDouble(0.7, 1, _curvedAnimation.value),
        child: widget.child,
      ),
    );
  }

  Widget _buildDisappearingView() {
    return Opacity(
      opacity: _curvedAnimation.value,
      child: widget.isInGrid
          ? Transform.scale(
              alignment: Alignment.center,
              scale: lerpDouble(0.7, 1, _curvedAnimation.value),
              child: widget.child,
            )
          : SizeTransition(
              sizeFactor: _curvedAnimation,
              child: widget.child,
            ),
    );
  }

  Widget _buildGridReorderingView() {
    if (_gridItemOffsetAnimation != null) {
      return Transform.translate(
        offset: _gridItemOffsetAnimation!.value,
        child: widget.child,
      );
    } else {
      return const SizedBox();
    }
  }

  void _animationListener() {
    setState(() {});
  }

  void _checkItemReordering() {
    if (!widget.isInGrid || widget.oldIndex == -1) {
      return;
    }
    final xOrderOld = (widget.oldIndex % widget.gridColumnCount) + 1;
    final yOrderOld = ((widget.oldIndex + 1) / widget.gridColumnCount).ceil();
    final xOrder = (widget.index % widget.gridColumnCount) + 1;
    final yOrder = ((widget.index + 1) / widget.gridColumnCount).ceil();
    final beginOffset = Offset(
      (xOrderOld - xOrder) * widget.singleGridItemXOffset,
      (yOrderOld - yOrder) * widget.singleGridItemYOffset,
    );

    if (beginOffset.dx != 0 || beginOffset.dy != 0) {
      _gridItemOffsetAnimation = Tween(begin: beginOffset, end: Offset.zero).animate(_curvedAnimation);
    }
  }

  @override
  void dispose() {
    _animationCtrl.dispose();
    super.dispose();
  }
}

class _ItemRemovalCallback {
  Future<void> Function()? run;
}

class ListItemRemoveExecutor {
  void Function(Object itemKey, VoidCallback fn)? run;
}

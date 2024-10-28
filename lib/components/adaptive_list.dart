import 'dart:ui';
import 'package:flutter/material.dart';

const kItemAnimationDuration = Duration(milliseconds: 450);

class AdaptiveList<T extends AdaptiveListItem> extends StatefulWidget {
  const AdaptiveList({
    super.key,
    required this.gridItemWidth,
    required this.gridItemHeight,
    required this.items,
    required this.itemBuilder,
    this.listPadding,
    this.gridTopPadding = 0,
    this.gridBottomPadding = 0,
  });

  final double gridItemWidth;
  final double gridItemHeight;
  final List<T> items;
  final Widget? Function(BuildContext context, dynamic item) itemBuilder;
  final EdgeInsetsGeometry? listPadding;
  final double gridTopPadding;
  final double gridBottomPadding;

  @override
  State<AdaptiveList> createState() => _AdaptiveListState();
}

class _AdaptiveListState extends State<AdaptiveList> {
  final List<AdaptiveListItem> _currentItems = [];
  final List<AdaptiveListItem> _oldItems = [];
  final List<AdaptiveListItem> _currentlyVisibleItems = [];
  final Map<Object, int> _itemsIndices = {};
  final Map<Object, _ItemRemovalCallback> _itemsRemovalCallbacks = {};

  @override
  void initState() {
    super.initState();
    _currentItems.addAll(widget.items);
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
        itemCount: _currentItems.length,
        itemBuilder: (context, index) {
          final item = _currentItems[index];
          final oldIndex = _getOldIndex(item.itemId, index);
          return _AnimatedItem(
            key: ObjectKey(item.itemId),
            index: index,
            oldIndex: oldIndex,
            isInserted: oldIndex == -1 && index < _oldItems.length,
            itemRemovalCallback: _getItemRemovalCallback(item.itemId),
            child: widget.itemBuilder(context, item) ?? const SizedBox(),
            onInit: () {
              _currentlyVisibleItems.add(item);
            },
            onDispose: () {
              _currentlyVisibleItems.remove(item);
            },
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
        itemCount: _currentItems.length,
        itemBuilder: (context, index) {
          final item = _currentItems[index];
          final oldIndex = _getOldIndex(item.itemId, index);
          return _AnimatedItem(
            key: ObjectKey(item.itemId),
            index: index,
            oldIndex: oldIndex,
            itemRemovalCallback: _getItemRemovalCallback(item.itemId),
            isInGrid: true,
            isInserted: oldIndex == -1 && index < _oldItems.length,
            gridColumnCount: columnCount,
            singleGridItemXOffset: widget.gridItemWidth + itemHorizontalSpacing,
            singleGridItemYOffset: widget.gridItemHeight + verticalSpacing,
            child: widget.itemBuilder(context, item) ?? const SizedBox(),
            onInit: () {
              _currentlyVisibleItems.add(item);
            },
            onDispose: () {
              _currentlyVisibleItems.remove(item);
            },
          );
        },
      ),
    );
  }

  int _getOldIndex(Object itemId, int newIndex) {
    final old = _itemsIndices[itemId] ?? -1;
    _itemsIndices[itemId] = newIndex;
    if (old == -2) {
      // will be -2 if there was a recalculation and this item was not visible.
      // return newIndex to avoid replaying 'enter' or 'reordering' animation.
      return newIndex;
    } else {
      return old;
    }
  }

  _ItemRemovalCallback _getItemRemovalCallback(Object itemId) {
    final old = _itemsRemovalCallbacks[itemId];
    if (old != null) return old;
    final newValue = _ItemRemovalCallback();
    _itemsRemovalCallbacks[itemId] = newValue;
    return newValue;
  }

  void _updateLists() {
    _oldItems.clear();
    _oldItems.addAll(_currentItems);
    _currentItems.clear();
    _currentItems.addAll(widget.items);
  }

  void _recalculateIndices() {
    for (final k in _itemsIndices.keys) {
      bool found = false;
      for (final e in _currentlyVisibleItems) {
        if (e.itemId == k) {
          found = true;
          break;
        }
      }
      if (!found) {
        _itemsIndices[k] = -2;
      }
    }
  }

  bool _checkRemovedItems() {
    final itemsRemoveCallbacks = <Object, _ItemRemovalCallback>{};
    for (int i = 0; i < _currentItems.length; i++) {
      final item = _currentItems[i];
      final newIndex = widget.items.indexOf(item);
      if (newIndex == -1) {
        // item is removed
        final callback = _itemsRemovalCallbacks[item.itemId];
        if (callback != null) {
          itemsRemoveCallbacks[item.itemId] = callback;
        }
      }
    }

    if (itemsRemoveCallbacks.isNotEmpty) {
      for (final itemId in itemsRemoveCallbacks.keys) {
        final callback = itemsRemoveCallbacks[itemId];
        if (callback != null && callback.run != null) {
          _recalculateIndices();
          callback.run!().then((_) {
            _itemsRemovalCallbacks.removeWhere((key, value) => value == callback);
          });
        }
      }
      Future.delayed(kItemAnimationDuration, () {
        if (mounted) {
          setState(() => _updateLists());
        }
      });
      return true;
    } else {
      return false;
    }
  }

  @override
  void didUpdateWidget(covariant AdaptiveList oldWidget) {
    if (!_checkRemovedItems()) {
      if (_currentItems.length < widget.items.length) {
        _recalculateIndices();
      }
      _updateLists();
    }
    super.didUpdateWidget(oldWidget);
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
    this.isInserted = false,
    this.gridColumnCount = 0,
    required this.itemRemovalCallback,
    this.onInit,
    this.onDispose,
  });

  final bool isInGrid;
  final bool isInserted;
  final int gridColumnCount;
  final Widget child;
  final int index;
  final int oldIndex;
  final double singleGridItemXOffset;
  final double singleGridItemYOffset;
  final _ItemRemovalCallback itemRemovalCallback;
  final void Function()? onInit;
  final void Function()? onDispose;

  @override
  State<_AnimatedItem> createState() => _AnimatedItemState();
}

class _AnimatedItemState extends State<_AnimatedItem> with SingleTickerProviderStateMixin {
  late final AnimationController _animationCtrl;
  late final CurvedAnimation _curvedAnimation;
  Animation<Offset>? _gridItemOffsetAnimation;
  bool _removed = false;

  @override
  void initState() {
    super.initState();
    if (widget.onInit != null) {
      widget.onInit!();
    }
    _animationCtrl = AnimationController(
      vsync: this,
      duration: kItemAnimationDuration,
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
        _animationCtrl.reverse().whenCompleteOrCancel(() {
          _removed = true;
          widget.itemRemovalCallback.run = null;
        });
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
      if (widget.isInGrid && widget.isInserted) {
        Future.delayed(kItemAnimationDuration * 0.5, () {
          if (mounted) {
            _animationCtrl.forward(from: 0);
          }
        });
      } else {
        _animationCtrl.forward(from: 0);
      }
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
        return _removed || (widget.isInGrid && widget.isInserted) ? const SizedBox() : _buildAppearingView();
      case AnimationStatus.forward:
      case AnimationStatus.completed:
        return _buildAppearingView();
    }
  }

  Widget _buildAppearingView() {
    return Opacity(
      opacity: _curvedAnimation.value,
      child: (!widget.isInGrid && widget.isInserted)
          ? SizeTransition(
              sizeFactor: _curvedAnimation,
              child: widget.child,
            )
          : Transform.scale(
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
    if (widget.onDispose != null) {
      widget.onDispose!();
    }
    super.dispose();
  }
}

class _ItemRemovalCallback {
  Future<void> Function()? run;
}

abstract class AdaptiveListItem {
  Object get itemId;
}

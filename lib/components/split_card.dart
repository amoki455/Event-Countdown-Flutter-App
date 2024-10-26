import 'package:flutter/material.dart';

class SplitCard extends StatelessWidget {
  const SplitCard({
    super.key,
    required this.top,
    required this.bottom,
  });

  final Widget top;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    final bottomColor = Theme.of(context).colorScheme.surface.withOpacity(0.4);
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          child: top,
        ),
        subtitle: Container(
          decoration: BoxDecoration(
            color: bottomColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 4,
          ),
          child: bottom,
        ),
      ),
    );
  }
}

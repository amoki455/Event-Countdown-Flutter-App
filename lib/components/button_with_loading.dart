import 'package:flutter/material.dart';

class ElevatedButtonWithLoading extends StatelessWidget {
  const ElevatedButtonWithLoading({
    super.key,
    required this.label,
    this.loadingLabel,
    required this.enableLoadingState,
    this.fontSize,
    required this.onPressed,
  });

  final String label;
  final String? loadingLabel;
  final bool enableLoadingState;
  final double? fontSize;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enableLoadingState ? null : onPressed,
      child: AnimatedCrossFade(
        alignment: Alignment.center,
        firstChild: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        secondChild: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              if (loadingLabel != null) ...[
                const SizedBox(width: 8),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(loadingLabel ?? ""),
                )
              ]
            ],
          ),
        ),
        crossFadeState: enableLoadingState
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 250),
      ),
    );
  }
}

class TextButtonWithLoading extends StatelessWidget {
  const TextButtonWithLoading({
    super.key,
    required this.label,
    this.loadingLabel,
    required this.enableLoadingState,
    this.fontSize,
    required this.onPressed,
  });

  final String label;
  final String? loadingLabel;
  final bool enableLoadingState;
  final double? fontSize;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: enableLoadingState ? null : onPressed,
      child: AnimatedCrossFade(
        alignment: Alignment.center,
        firstChild: Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        secondChild: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              if (loadingLabel != null) ...[
                const SizedBox(width: 8),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(loadingLabel ?? ""),
                )
              ]
            ],
          ),
        ),
        crossFadeState: enableLoadingState
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 250),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../button_with_loading.dart';

class EventInfoDialogActions extends StatefulWidget {
  const EventInfoDialogActions({
    super.key,
    required this.submitText,
    required this.onSubmit,
    required this.isLoading,
  });

  final String submitText;
  final void Function() onSubmit;
  final bool isLoading;

  @override
  State<EventInfoDialogActions> createState() => _EventInfoDialogActionsState();
}

class _EventInfoDialogActionsState extends State<EventInfoDialogActions> {
  // To avoid multiple clicks which cause navigation back after closing the dialog
  var _isCancelPressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 36,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: TextButton(
                onPressed: !_isCancelPressed
                    ? () {
                        setState(() {
                          _isCancelPressed = true;
                        });
                        Get.back();
                      }
                    : null,
                child: const Text(
                  "Cancel",
                  softWrap: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              fit: FlexFit.loose,
              child: TextButtonWithLoading(
                onPressed: widget.onSubmit,
                label: widget.submitText,
                loadingLabel: widget.submitText,
                enableLoadingState: widget.isLoading,
              ),
            )
          ],
        ),
      ),
    );
  }
}

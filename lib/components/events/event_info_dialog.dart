import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/events/event_details_page_controller.dart';
import '../../data/event.dart';
import 'details_form/dialog_actions.dart';
import 'details_form/dialog_header.dart';
import 'details_form/event_date_field.dart';
import 'details_form/event_description_field.dart';
import 'details_form/event_time_field.dart';
import 'details_form/event_title_field.dart';

class EventInfoDialog extends StatefulWidget {
  const EventInfoDialog({
    super.key,
    this.event,
  });

  final Event? event;

  @override
  State<EventInfoDialog> createState() => _EventInfoDialogState();
}

class _EventInfoDialogState extends State<EventInfoDialog> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<EventDetailsPageController>() ? Get.find<EventDetailsPageController>() : Get.put(EventDetailsPageController(currentEvent: widget.event));

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Card(
          color: Color.alphaBlend(
            Get.theme.colorScheme.primary.withOpacity(0.1),
            Get.theme.cardTheme.color ?? Colors.black54,
          ),
          child: Stack(
            children: [
              DialogHeader(
                title: widget.event == null ? "Add new event" : "Edit event details",
              ),
              buildActions(controller),
              buildForm(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActions(EventDetailsPageController controller) {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Obx(() {
        return EventInfoDialogActions(
          submitText: widget.event == null ? "Submit" : "Update",
          onSubmit: () async {
            final newEvent = await (widget.event == null ? controller.submitEvent() : controller.updateEvent());

            if (newEvent != null && mounted) {
              Get.back(result: newEvent);
            }
          },
          isLoading: controller.isLoading.value,
        );
      }),
    );
  }

  Widget buildForm(EventDetailsPageController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 64, bottom: 64),
      child: ListView(
        padding: const EdgeInsets.all(4),
        shrinkWrap: true,
        children: [
          EventTitleField(controller: controller.titleTextController),
          EventDescriptionField(
            controller: controller.descriptionTextController,
          ),
          Obx(() {
            return EventDateField(
              currentValue: controller.date.value,
              onValueChanged: (value) {
                controller.date.value = value;
              },
            );
          }),
          Obx(() {
            return EventTimeField(
              currentValue: controller.time.value,
              onValueChanged: (value) {
                controller.time.value = value;
              },
            );
          }),
        ],
      ),
    );
  }
}

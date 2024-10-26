import 'dart:io';
import 'package:event_countdown/data/repository/events_repository.dart';
import 'package:event_countdown/data/repository/supabase_events_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/event.dart';
import '../shell_controller.dart';

class EventDetailsPageController extends GetxController {
  EventDetailsPageController({
    Event? currentEvent,
    EventsRepository? eventsRepository,
    ShellController? shellController,
  })  : eventUID = currentEvent?.id.obs ?? ''.obs,
        _eventsRepository = eventsRepository ?? SupabaseEventsRepository(),
        _shellController = shellController ?? Get.find() {
    if (currentEvent != null) {
      titleTextController.text = currentEvent.title;
      descriptionTextController.text = currentEvent.description ?? "";
      date.value = currentEvent.getUtcDate()?.toLocal() ?? DateTime.now();
      time.value = TimeOfDay.fromDateTime(date.value);
    }
  }

  final EventsRepository _eventsRepository;
  final ShellController _shellController;
  final RxString eventUID;

  final titleTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final date = DateTime.now().obs;
  final time = TimeOfDay.now().obs;
  final isLoading = false.obs;

  Future<Event?> submitEvent() async {
    if (isLoading.value == true) return null;
    try {
      isLoading.value = true;

      if (titleTextController.text.isEmpty) {
        _shellController.showSnackbar(
          "Insufficient data",
          "Title can not be empty",
          icon: Icons.error,
        );
        return null;
      }

      final event = Event(
        id: "",
        userId: "",
        title: titleTextController.text,
        description: descriptionTextController.text,
        eventTimestampUTC: date.value
            .copyWith(
              hour: time.value.hour,
              minute: time.value.minute,
            )
            .toUtc()
            .toString(),
        createdAtTimestampUTC: "",
      );
      return await _eventsRepository.insertEvent(event);
    } on Exception catch (e) {
      handleException(e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<Event?> updateEvent() async {
    if (isLoading.value == true) return null;
    try {
      isLoading.value = true;

      if (titleTextController.text.isEmpty) {
        _shellController.showSnackbar(
          "Insufficient data",
          "Title can not be empty",
          icon: Icons.error,
        );
        return null;
      }

      final event = Event(
        id: eventUID.value,
        userId: "",
        title: titleTextController.text,
        description: descriptionTextController.text,
        eventTimestampUTC: date.value
            .copyWith(
              hour: time.value.hour,
              minute: time.value.minute,
            )
            .toUtc()
            .toString(),
        createdAtTimestampUTC: "",
      );
      return await _eventsRepository.updateEvent(event);
    } on Exception catch (e) {
      handleException(e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void handleException(Exception error) {
    String errorMsg = "";
    if (error is AuthException) {
      errorMsg = error.message;
    } else if (error is PostgrestException) {
      errorMsg = error.details.toString();
    } else if (error is SocketException) {
      errorMsg = "Failed to connect. Check your internet connection.";
    } else {
      errorMsg = error.toString();
    }

    _shellController.showSnackbar(
      "Error",
      errorMsg,
      icon: Icons.error,
    );
  }

  @override
  void dispose() {
    super.dispose();
    titleTextController.dispose();
    descriptionTextController.dispose();
  }
}

import 'dart:io';
import 'package:event_countdown/controllers/notifications/notifications_controller.dart';
import 'package:event_countdown/data/repository/events_repository.dart';
import 'package:event_countdown/data/repository/supabase_events_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/event.dart';
import '../shell_controller.dart';

class EventsPageController extends GetxController {
  EventsPageController({
    EventsRepository? repository,
    ShellController? shellController,
    NotificationsController? notificationsController,
  })  : _repository = repository ?? SupabaseEventsRepository(),
        _shellController = shellController ?? Get.find(),
        _notificationsController = notificationsController ?? Get.find();

  final EventsRepository _repository;
  final ShellController _shellController;
  final NotificationsController _notificationsController;

  final isLoading = false.obs;
  final events = <Event>[].obs;
  final Rx<Exception?> error = Rx<Exception?>(null);

  void loadEvents() async {
    if (isLoading.value == true) return;
    try {
      isLoading.value = true;
      events.addAll(await _repository.getEvents());
      _scheduleNotifications();
    } on Exception catch (e) {
      error.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteEvent(String id) async {
    try {
      await _repository.deleteEvent(id);
      _notificationsController.cancelEventNotifications(id);
      return true;
    } on Exception catch (e) {
      String errorMsg = "";
      if (e is AuthException) {
        errorMsg = e.message;
      } else if (e is PostgrestException) {
        errorMsg = e.details.toString();
      } else if (e is SocketException) {
        errorMsg = "Failed to connect. Check your internet connection.";
      } else {
        errorMsg = e.toString();
      }

      _shellController.showSnackbar(
        "Error",
        errorMsg,
        icon: Icons.error,
      );
      return false;
    }
  }

  void _scheduleNotifications() {
    for (final event in events) {
      _notificationsController.scheduleEventNotifications(event);
    }
  }
}

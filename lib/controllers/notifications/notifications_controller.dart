import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';

import '../../data/event.dart';

class NotificationsController extends GetxController {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const _androidND = AndroidNotificationDetails(
    "events_channel",
    "Events",
    importance: Importance.max,
    priority: Priority.max,
    enableLights: true,
    ledOnMs: 800,
    ledOffMs: 200,
    ledColor: Colors.blue,
  );

  NotificationsController() {
    _init();
  }

  Future<bool?> _init() async {
    const initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
    final initializationSettingsDarwin = DarwinInitializationSettings(onDidReceiveLocalNotification: (id, title, body, payload) {});
    const initializationSettingsLinux = LinuxInitializationSettings(defaultActionName: 'Open');
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );
    return await _flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (details) {});
  }

  void scheduleNotification(int id, String title, String details, DateTime utcDateTime) {
    if (Platform.isWindows) {
      return;
    }
    _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      details,
      tz.TZDateTime.from(utcDateTime, tz.local),
      const NotificationDetails(android: _androidND),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void cancelNotification(int id) {
    if (Platform.isWindows) {
      return;
    }
    _flutterLocalNotificationsPlugin.cancel(id);
  }

  void cancelAllNotifications() {
    if (Platform.isWindows) {
      return;
    }
    _flutterLocalNotificationsPlugin.cancelAll();
  }

  void scheduleEventNotifications(Event event) {
    final eventDateTime = event.getUtcDate() ?? DateTime.now();
    if (eventDateTime.difference(DateTime.now()).inSeconds <= 0) {
      return;
    }

    final firstNotificationId = '${event.id}-before 15 min'.hashCode;
    final secondNotificationId = event.id.hashCode;

    final firstNotificationDatetime = eventDateTime.subtract(const Duration(minutes: 15));
    if (firstNotificationDatetime.difference(DateTime.now()).inSeconds > 0) {
      scheduleNotification(
        firstNotificationId,
        'Get ready, the event is about to start!',
        'The event (${event.title}) will start in 15 minutes.',
        firstNotificationDatetime,
      );
    }

    scheduleNotification(secondNotificationId, event.title, 'The event has started.', eventDateTime);
  }

  void cancelEventNotifications(String eventId) {
    final firstNotificationId = '$eventId-before 15 min'.hashCode;
    final secondNotificationId = eventId.hashCode;
    cancelNotification(firstNotificationId);
    cancelNotification(secondNotificationId);
  }
}

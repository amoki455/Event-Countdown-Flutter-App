import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';

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
    _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      details,
      tz.TZDateTime.from(utcDateTime, tz.local),
      const NotificationDetails(android: _androidND),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  void cancelNotification(int id) => _flutterLocalNotificationsPlugin.cancel(id);

  void cancelAllNotifications() => _flutterLocalNotificationsPlugin.cancelAll();
}

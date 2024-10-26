import 'package:event_countdown/controllers/notifications/notifications_controller.dart';
import 'package:event_countdown/data/constants.dart';
import 'package:event_countdown/pages/account_page.dart';
import 'package:event_countdown/pages/events_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'controllers/auth/authentication_controller.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: Constants.supabaseUrl, anonKey: Constants.supabaseAnonKey);
  tz.initializeTimeZones();
  Get.put(NotificationsController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthenticationController(), permanent: true);
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blueAccent,
      brightness: Brightness.dark,
    );
    return GetMaterialApp(
      title: 'Events Countdown',
      theme: ThemeData(
        colorScheme: colorScheme,
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(
              Color.alphaBlend(
                colorScheme.surface.withOpacity(0.85),
                colorScheme.surfaceTint,
              ),
            ),
          ),
        ),
        cardTheme: CardTheme(
          color: Color.alphaBlend(
            colorScheme.surface.withOpacity(0.9),
            colorScheme.primary,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: const UnderlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.elliptical(16, 16),
            ),
          ),
          filled: true,
          fillColor: colorScheme.inversePrimary.withAlpha(60),
        ),
      ),
      home: Obx(() {
        return authController.currentUser.value == null ? const AccountPage() : const EventsPage();
      }),
    );
  }
}

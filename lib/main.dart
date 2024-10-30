import 'package:event_countdown/controllers/auth/account_page_controller.dart';
import 'package:event_countdown/controllers/events/events_page_controller.dart';
import 'package:event_countdown/controllers/notifications/notifications_controller.dart';
import 'package:event_countdown/controllers/shell_controller.dart';
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
  Get.put(AuthenticationController(), permanent: true);
  Get.put(ShellController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<AuthenticationController>().init();
    });
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.blueAccent,
      brightness: Brightness.dark,
    );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Events Countdown',
      initialRoute: "/account",
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/account":
            return GetPageRoute(
              title: "Account",
              bindings: [BindingsBuilder.put(() => AccountPageController())],
              page: () => const AccountPage(),
              transition: Transition.native,
              transitionDuration: const Duration(milliseconds: 420),
              curve: Curves.fastEaseInToSlowEaseOut,
            );
          case "/events":
            return GetPageRoute(
              title: "Events",
              bindings: [BindingsBuilder.put(() => EventsPageController())],
              page: () => const EventsPage(),
              transition: Transition.native,
              transitionDuration: const Duration(milliseconds: 420),
              curve: Curves.fastEaseInToSlowEaseOut,
            );
          default:
            return null;
        }
      },
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
    );
  }
}

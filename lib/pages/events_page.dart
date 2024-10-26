import 'package:event_countdown/controllers/auth/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthenticationController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Events",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text("Reload"),
                  onTap: () {},
                ),
                PopupMenuItem(
                  child: const Text("Logout"),
                  onTap: () {
                    authController.signOut();
                    Get.offNamed("/account");
                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: const Placeholder(),
    );
  }
}

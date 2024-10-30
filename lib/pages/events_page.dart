import 'dart:io';
import 'dart:ui';
import 'package:event_countdown/components/events/event_card.dart';
import 'package:event_countdown/controllers/auth/authentication_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/adaptive_list.dart';
import '../components/events/event_info_dialog.dart';
import '../controllers/events/events_page_controller.dart';
import '../data/event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<EventsPageController>();
    if (controller.events.isEmpty) {
      controller.loadEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthenticationController>();
    final controller = Get.find<EventsPageController>();
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
                  onTap: () {
                    controller.events.clear();
                    controller.loadEvents();
                  },
                ),
                PopupMenuItem(
                  child: const Text("Logout"),
                  onTap: () {
                    authController.signOut();
                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: Obx(() {
          return AnimatedCrossFade(
            alignment: Alignment.center,
            firstChild: controller.events.isNotEmpty
                ? _buildListView()
                : controller.error.value == null
                    ? _buildEmptyView()
                    : _buildErrorView(),
            secondChild: _buildLoadingView(),
            crossFadeState: controller.isLoading.value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await _openEventDetailsDialog(null);
          if (result is Event) {
            controller.events.add(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView() {
    final controller = Get.find<EventsPageController>();
    return AdaptiveList(
      gridItemWidth: 300,
      gridItemHeight: 200,
      gridBottomPadding: 80,
      listPadding: const EdgeInsets.only(
        left: 4,
        right: 4,
        top: 4,
        bottom: 80,
      ),
      items: controller.events,
      itemBuilder: (context, item) => EventCard(
        title: item.title,
        description: item.description ?? "",
        dateTimeUTC: item.getUtcDate() ?? DateTime.now(),
        onEditClick: () async {
          final index = controller.events.indexOf(item);
          if (index != -1) {
            final result = await _openEventDetailsDialog(item);
            if (result is Event) {
              controller.events[index] = result;
            }
          }
        },
        onDeleteClick: () {
          final index = controller.events.indexOf(item);
          if (index != -1) {
            _openDeleteConfirmationDialog(controller.events[index], index);
          }
        },
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyView() {
    return const Center(
      child: Text(
        "You don't have any events.\nClick on '+' button to add a new event.",
        textAlign: TextAlign.center,
        softWrap: true,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    final controller = Get.find<EventsPageController>();
    final error = controller.error.value;
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

    return CupertinoAlertDialog(
      title: const Text("Error"),
      content: Text(errorMsg),
      actions: [
        TextButton(
          onPressed: controller.loadEvents,
          child: const Text("Reload"),
        )
      ],
    );
  }

  Future<Event?> _openEventDetailsDialog(Event? currentEvent) async {
    final result = await Get.generalDialog(
      pageBuilder: (_, __, ___) => const SizedBox(),
      barrierDismissible: true,
      barrierLabel: "",
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnim = CurvedAnimation(parent: animation, curve: Curves.fastEaseInToSlowEaseOut);
        return Opacity(
          opacity: curvedAnim.value,
          child: Transform.scale(
            alignment: Alignment.center,
            scale: lerpDouble(0.7, 1, curvedAnim.value),
            child: EventInfoDialog(event: currentEvent),
          ),
        );
      },
    );
    return result;
  }

  void _openDeleteConfirmationDialog(Event event, int index) {
    final controller = Get.find<EventsPageController>();
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(
          "Really?",
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        message: Text("Do you want to delete this event (${event.title})?",
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            )),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.of(context).pop();
              controller.deleteEvent(controller.events[index].id);
              controller.events.removeAt(index);
            },
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
          ),
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("No", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }
}

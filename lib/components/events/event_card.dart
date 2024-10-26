import 'package:flutter/material.dart';
import '../countdown/countdown_view.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.title,
    this.description = "",
    required this.dateTimeUTC,
    this.onClick,
    this.onEditClick,
    this.onDeleteClick,
  });

  final String title;
  final String description;
  final DateTime dateTimeUTC;
  final void Function()? onClick;
  final void Function()? onEditClick;
  final void Function()? onDeleteClick;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Tooltip(
                          message: description,
                          waitDuration: const Duration(seconds: 1),
                          margin: const EdgeInsets.all(8),
                          child: Text(
                            title,
                            maxLines: 5,
                            overflow: TextOverflow.fade,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: onEditClick,
                          child: const Text("Edit"),
                        ),
                        PopupMenuItem(
                          onTap: onDeleteClick,
                          child: const Text("Delete"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Card(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                elevation: 0,
                margin: const EdgeInsets.all(5),
                child: CountDownView(timestampUTC: dateTimeUTC),
              )
            ],
          ),
        ),
      ),
    );
  }
}

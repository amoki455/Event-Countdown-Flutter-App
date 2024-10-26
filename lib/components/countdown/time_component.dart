import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeComponent extends StatelessWidget {
  const TimeComponent({super.key, required this.name, required this.value});

  final String name;
  final int value;

  @override
  Widget build(BuildContext context) {
    final valueStyle = Get.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.bold,
    );
    final nameStyle = Get.textTheme.labelSmall;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(3),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        value.toString(),
                        style: valueStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        name,
                        style: nameStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

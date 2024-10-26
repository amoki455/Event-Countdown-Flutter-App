import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DialogHeader extends StatelessWidget {
  const DialogHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
          color: Get.theme.colorScheme.inversePrimary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

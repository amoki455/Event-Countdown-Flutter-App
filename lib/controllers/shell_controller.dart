import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShellController extends GetxController {
  SnackbarController showSnackbar(
    String title,
    String message, {
    IconData? icon,
    int durationSeconds = 5,
    bool isDismissible = true,
    bool closeCurrentSnackbar = true,
    String? action,
    void Function()? actionCallback,
  }) {
    if (closeCurrentSnackbar) Get.closeCurrentSnackbar();

    return Get.snackbar(
      title,
      message,
      icon: icon != null
          ? Icon(
              icon,
              color: Get.theme.colorScheme.onInverseSurface,
            )
          : null,
      margin: const EdgeInsets.all(0),
      borderRadius: 0,
      forwardAnimationCurve: Curves.fastEaseInToSlowEaseOut,
      reverseAnimationCurve: Curves.fastEaseInToSlowEaseOut,
      duration: Duration(seconds: durationSeconds),
      mainButton: action != null
          ? TextButton(
              onPressed: actionCallback,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Get.theme.colorScheme.onInverseSurface,
                ),
              ),
              child: Text(action),
            )
          : null,
      isDismissible: isDismissible,
      snackPosition: SnackPosition.BOTTOM,
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: Get.theme.colorScheme.inverseSurface.withOpacity(0.7),
      colorText: Get.theme.colorScheme.onInverseSurface,
      barBlur: 5,
      messageText: Text(
        message,
        style: Get.theme.textTheme.bodyMedium?.copyWith(
          color: Get.theme.colorScheme.onInverseSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

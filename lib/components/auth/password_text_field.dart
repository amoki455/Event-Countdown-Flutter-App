import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/account_page_controller.dart';

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({super.key, this.newPassword = false});

  final bool newPassword;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountPageController>();

    return Obx(() {
      return TextField(
        controller: newPassword
            ? controller.newPasswordTextController
            : controller.passwordTextController,
        keyboardType: TextInputType.visiblePassword,
        autocorrect: false,
        enableSuggestions: false,
        obscureText: controller.hidePassword.value,
        decoration: InputDecoration(
          labelText: newPassword ? "New Password" : "Password",
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            onPressed: () {
              controller.hidePassword.value = !controller.hidePassword.value;
            },
            icon: Icon(
              controller.hidePassword.value
                  ? Icons.visibility_off
                  : Icons.visibility,
              semanticLabel: controller.hidePassword.value
                  ? "show password text"
                  : "hide password text",
            ),
          ),
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/account_page_controller.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountPageController>();

    return TextField(
      controller: controller.emailTextController,
      decoration: const InputDecoration(
        labelText: "Email",
        prefixIcon: Icon(Icons.alternate_email),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

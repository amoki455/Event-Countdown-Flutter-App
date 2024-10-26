import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/account_page_controller.dart';

class TokenTextField extends StatelessWidget {
  const TokenTextField({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountPageController>();

    return TextField(
      controller: controller.tokenTextController,
      decoration: InputDecoration(
        labelText: name,
        prefixIcon: const Icon(Icons.numbers),
      ),
      keyboardType: TextInputType.text,
    );
  }
}

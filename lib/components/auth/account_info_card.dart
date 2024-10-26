import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/authentication_controller.dart';
import 'buttons.dart';

class AccountInfoCard extends StatelessWidget {
  const AccountInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthenticationController>();
    final cardColor = Color.alphaBlend(
        Get.theme.colorScheme.surface.withOpacity(0.9),
        Get.theme.colorScheme.primary);

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 600),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Card(
          color: cardColor,
          elevation: 8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(16, 16)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Signed In",
                        style: Get.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Flexible(
                      fit: FlexFit.loose,
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: SignOutButton(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return Text(controller.currentUser.value?.email ?? "");
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

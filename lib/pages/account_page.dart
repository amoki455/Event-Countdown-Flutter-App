import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/auth/account_info_card.dart';
import '../components/auth/login_or_signup_card.dart';
import '../controllers/auth/authentication_controller.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthenticationController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              if (controller.currentUser.value != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) => Get.offNamed("/events"));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const FlutterLogo(size: 200),
                  const SizedBox(height: 20),
                  AnimatedCrossFade(
                    firstChild: const LoginOrSignupCard(),
                    secondChild: const AccountInfoCard(),
                    crossFadeState: controller.currentUser.value == null ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 250),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLogo(context),
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

  Widget _buildLogo(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        children: [
          Icon(
            Icons.event_note_outlined,
            size: 200,
            color: Theme.of(context).colorScheme.secondary,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.timer_rounded,
              size: 100,
              color: Theme.of(context).colorScheme.secondary,
              shadows: const [Shadow(blurRadius: 20, offset: Offset(0, -5))],
            ),
          ),
        ],
      ),
    );
  }
}

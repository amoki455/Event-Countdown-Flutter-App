import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/account_page_controller.dart';
import '../button_with_loading.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountPageController>();

    return ConstrainedBox(
      constraints: const BoxConstraints.expand(height: 54),
      child: Obx(() {
        return ElevatedButtonWithLoading(
          label: "Login",
          loadingLabel: "Logging in...",
          fontSize: 18,
          enableLoadingState: controller.isLoggingIn.value,
          onPressed: () {
            controller.signIn();
          },
        );
      }),
    );
  }
}

class SignupButton extends StatelessWidget {
  const SignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountPageController>();

    return ConstrainedBox(
      constraints: const BoxConstraints.expand(height: 54),
      child: Obx(() {
        return ElevatedButtonWithLoading(
          label: "SignUp",
          loadingLabel: "Creating a new account...",
          fontSize: 18,
          enableLoadingState: controller.isCreatingNewAccount.value,
          onPressed: () {
            controller.signUp();
          },
        );
      }),
    );
  }
}

class UpdatePasswordButton extends StatelessWidget {
  const UpdatePasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountPageController>();

    return ConstrainedBox(
      constraints: const BoxConstraints.expand(height: 54),
      child: Obx(() {
        return ElevatedButtonWithLoading(
          label: "Update Password",
          loadingLabel: "Updating password...",
          fontSize: 18,
          enableLoadingState: controller.isResettingPassword.value,
          onPressed: () {
            controller.updatePassword();
          },
        );
      }),
    );
  }
}

class ConfirmEmailButton extends StatelessWidget {
  const ConfirmEmailButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountPageController>();

    return ConstrainedBox(
      constraints: const BoxConstraints.expand(height: 54),
      child: Obx(() {
        return ElevatedButtonWithLoading(
          label: "Confirm email",
          loadingLabel: "Confirming...",
          enableLoadingState: controller.isConfirmingEmail.value,
          onPressed: () {
            controller.confirmEmail();
          },
        );
      }),
    );
  }
}

class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountPageController>();
    final buttonColor = WidgetStatePropertyAll(
      Color.alphaBlend(
        Get.theme.colorScheme.surface.withOpacity(0.85),
        Get.theme.colorScheme.surfaceTint,
      ),
    );

    return ElevatedButton(
      style: ButtonStyle(backgroundColor: buttonColor),
      onPressed: () {
        controller.signOut();
      },
      child: const Text(
        "Sign Out",
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

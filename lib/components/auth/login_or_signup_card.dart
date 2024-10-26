import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth/account_page_controller.dart';
import '../button_with_loading.dart';
import 'buttons.dart';
import 'email_text_field.dart';
import 'password_text_field.dart';
import 'token_text_field.dart';

class LoginOrSignupCard extends StatelessWidget {
  const LoginOrSignupCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountPageController>();

    return ConstrainedBox(
      constraints: BoxConstraints.loose(const Size.fromWidth(600)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Card(
          // color: cardColor,
          elevation: 8,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(16, 16)),
          ),
          child: Obx(() {
            final currentView = controller.currentView.value;
            return AnimatedCrossFade(
              firstChild: AnimatedCrossFade(
                firstChild: const _LoginView(),
                secondChild: const _SignupView(),
                crossFadeState: currentView == AccountPageView.signUp
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              ),
              secondChild: AnimatedCrossFade(
                firstChild: const _PasswordResetView(),
                secondChild: const _EmailConfirmationView(),
                crossFadeState: currentView == AccountPageView.confirmEmail
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              ),
              crossFadeState: currentView == AccountPageView.resetPassword ||
                      currentView == AccountPageView.confirmEmail
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            );
          }),
        ),
      ),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountPageController>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Welcome back",
            style: Get.textTheme.headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const EmailTextField(),
          const SizedBox(height: 16),
          const PasswordTextField(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 40),
                    child: TextButton(
                      onPressed: () {
                        controller.currentView.value = AccountPageView.signUp;
                      },
                      child: const Text("Create a new account"),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Obx(() {
                    return ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 40),
                      child: TextButtonWithLoading(
                        label: "Forgot Password?",
                        loadingLabel: "Resetting...",
                        enableLoadingState:
                            controller.isResettingPassword.value,
                        onPressed: () {
                          controller.sendPasswordResetEmail();
                        },
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const LoginButton(),
        ],
      ),
    );
  }
}

class _SignupView extends StatelessWidget {
  const _SignupView();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountPageController>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "New Account",
            style: Get.textTheme.headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const EmailTextField(),
          const SizedBox(height: 16),
          const PasswordTextField(),
          const SizedBox(height: 8),
          Obx(() {
            return Row(
              children: [
                Checkbox(
                  value: controller.acceptedTerms.value,
                  onChanged: (value) =>
                      controller.acceptedTerms.value = value ?? false,
                  semanticLabel: "I accept terms and conditions.",
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: TextButton(
                    onPressed: () {
                      controller.acceptedTerms.value =
                          !controller.acceptedTerms.value;
                    },
                    child: const Text("I accept terms and conditions."),
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton(
                    onPressed: () {
                      controller.currentView.value = AccountPageView.login;
                    },
                    child: const Text("Already have an account?"),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const SignupButton(),
        ],
      ),
    );
  }
}

class _PasswordResetView extends StatelessWidget {
  const _PasswordResetView();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountPageController>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Center(
                child: Text(
                  "Reset Password",
                  overflow: TextOverflow.ellipsis,
                  style: Get.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: IconButton(
                  onPressed: () {
                    controller.currentView.value = AccountPageView.login;
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          const TokenTextField(name: "Reset code"),
          const SizedBox(height: 16),
          const PasswordTextField(newPassword: true),
          const SizedBox(height: 16),
          const UpdatePasswordButton(),
        ],
      ),
    );
  }
}

class _EmailConfirmationView extends StatelessWidget {
  const _EmailConfirmationView();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AccountPageController>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Center(
                child: Text(
                  "Confirm your email",
                  overflow: TextOverflow.ellipsis,
                  style: Get.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: IconButton(
                  onPressed: () {
                    controller.currentView.value = AccountPageView.login;
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 24),
          const TokenTextField(name: "Email confirmation code"),
          const SizedBox(height: 16),
          const ConfirmEmailButton(),
        ],
      ),
    );
  }
}

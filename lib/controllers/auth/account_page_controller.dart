import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../shell_controller.dart';

class AccountPageController extends GetxController {
  AccountPageController({
    ShellController? shellController,
    GoTrueClient? authClient,
  }) {
    _shellController = shellController ?? Get.find();
    _authClient = authClient ?? Supabase.instance.client.auth;
  }

  late ShellController _shellController;
  late GoTrueClient _authClient;

  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController tokenTextController = TextEditingController();
  final TextEditingController newPasswordTextController =
      TextEditingController();
  final hidePassword = true.obs;
  final acceptedTerms = false.obs;

  // To show loading state and prevent multiple clicks
  final isCreatingNewAccount = false.obs;
  final isLoggingIn = false.obs;
  final isResettingPassword = false.obs;
  final isConfirmingEmail = false.obs;

  final currentView = AccountPageView.login.obs;

  void signUp() async {
    isCreatingNewAccount.value = true;
    try {
      if (!_checkFields()) return;

      if (!acceptedTerms.value) {
        _shellController.showSnackbar(
          "Can not create a new account",
          "You must accept terms and conditions.",
          icon: Icons.error,
        );
        return;
      }

      final response = await _authClient.signUp(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      if (response.user != null) {
        emailTextController.text = "";
        passwordTextController.text = "";
        _shellController.showSnackbar(
          "Success",
          "Created new account successfully",
          icon: Icons.done,
        );
      }
    } on AuthException catch (authError) {
      _handleAuthError(authError);
    } catch (e) {
      _handleUnknownError(e);
    } finally {
      isCreatingNewAccount.value = false;
    }
  }

  void signIn() async {
    isLoggingIn.value = true;
    try {
      if (!_checkFields()) return;

      await _authClient.signInWithPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      emailTextController.text = "";
      passwordTextController.text = "";
      _shellController.showSnackbar(
        "Success",
        "Logged in successfully",
        icon: Icons.done,
      );
    } on AuthException catch (authError) {
      _handleAuthError(authError);
    } catch (e) {
      _handleUnknownError(e);
    } finally {
      isLoggingIn.value = false;
    }
  }

  void signOut() {
    _authClient.signOut();
  }

  void sendPasswordResetEmail() async {
    try {
      isResettingPassword.value = true;
      if (emailTextController.text.isEmpty) {
        _shellController.showSnackbar(
          "Forgot Password?",
          "Enter your email then click on 'Forgot Password' button.",
          icon: Icons.lock_reset,
        );
        return;
      }

      await _authClient.resetPasswordForEmail(emailTextController.text);

      currentView.value = AccountPageView.resetPassword;

      _shellController.showSnackbar(
        "Password Reset",
        "Check your email for instructions to reset your password.",
        icon: Icons.done,
      );
    } on AuthException catch (authError) {
      _handleAuthError(authError);
    } catch (e) {
      _handleUnknownError(e);
    } finally {
      isResettingPassword.value = false;
    }
  }

  void updatePassword() async {
    try {
      isResettingPassword.value = true;
      if (tokenTextController.text.isEmpty) {
        _shellController.showSnackbar(
          "Forgot Password?",
          "Reset code can not be empty.",
          icon: Icons.lock_reset,
        );
        return;
      }

      if (newPasswordTextController.text.isEmpty) {
        _shellController.showSnackbar(
          "Forgot Password?",
          "Please enter a new password.",
          icon: Icons.lock_reset,
        );
        return;
      }

      final response = await _authClient.verifyOTP(
        email: emailTextController.text,
        token: tokenTextController.text,
        type: OtpType.recovery,
      );

      if (response.user != null) {
        await _authClient.updateUser(
          UserAttributes(
            password: newPasswordTextController.text,
          ),
        );
        currentView.value = AccountPageView.login;
      }
    } on AuthException catch (authError) {
      _handleAuthError(authError);
    } catch (e) {
      _handleUnknownError(e);
    } finally {
      isResettingPassword.value = false;
    }
  }

  void confirmEmail() async {
    try {
      isConfirmingEmail.value = true;
      final response = await _authClient.verifyOTP(
        type: OtpType.email,
        token: tokenTextController.text,
        email: emailTextController.text,
      );

      if (response.user != null) {
        _shellController.showSnackbar(
          "Done",
          "Email is confirmed, you can login now.",
          icon: Icons.done,
        );
        currentView.value = AccountPageView.login;
      }
    } on AuthException catch (authError) {
      _handleAuthError(authError);
    } catch (e) {
      _handleUnknownError(e);
    } finally {
      isConfirmingEmail.value = false;
    }
  }

  void _handleAuthError(AuthException authError) {
    String errorMsg = "";
    if (authError is AuthRetryableFetchException) {
      errorMsg = "Failed to connect. Check your internet connection.";
    } else {
      errorMsg = authError.code == "unknown-error"
          ? "Invalid email or password."
          : authError.message;
    }

    _shellController.showSnackbar(
      "Error",
      errorMsg,
      icon: Icons.error,
    );

    if (authError.code == "email_not_confirmed") {
      currentView.value = AccountPageView.confirmEmail;
    }
  }

  void _handleUnknownError(Object e) {
    String errorMsg = "";
    if (e is SocketException) {
      errorMsg = "Failed to connect. Check your internet connection.";
    } else {
      errorMsg = e.toString();
    }

    _shellController.showSnackbar(
      "Error",
      errorMsg,
      icon: Icons.error,
    );
  }

  bool _checkFields() {
    if (emailTextController.text.isEmpty) {
      _shellController.showSnackbar(
        "Error",
        "Email can not be empty.",
        icon: Icons.error,
      );
      return false;
    }

    if (passwordTextController.text.isEmpty) {
      _shellController.showSnackbar(
        "Error",
        "Password can not be empty.",
        icon: Icons.error,
      );
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    super.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
  }
}

enum AccountPageView {
  login,
  signUp,
  resetPassword,
  confirmEmail,
}

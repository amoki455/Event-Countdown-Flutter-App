import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/app_user.dart';
import '../notifications/notifications_controller.dart';

class AuthenticationController extends GetxController {
  AuthenticationController({
    GoTrueClient? authClient,
    NotificationsController? notificationsController,
  })  : _authClient = authClient ?? Supabase.instance.client.auth,
        _notificationsController = notificationsController ?? Get.find();

  late final GoTrueClient _authClient;
  final currentUser = Rx<AppUser?>(null);
  StreamSubscription<AuthState>? _userStreamSubscription;
  final NotificationsController _notificationsController;

  void init() {
    _userStreamSubscription ??= _listen();
  }

  StreamSubscription<AuthState> _listen() {
    return _authClient.onAuthStateChange.listen(
      (data) {
        if (data.event == AuthChangeEvent.passwordRecovery) {
          return;
        }
        final user = data.session?.user;
        if (user == null) {
          Get.offNamed("/account");
          currentUser.value = null;
          _notificationsController.cancelAllNotifications();
        } else {
          Get.offNamed("/events");
          currentUser.value = AppUser(uid: user.id, email: user.email ?? "");
        }
      },
    );
  }

  void signOut() {
    _authClient.signOut();
  }

  @override
  void dispose() {
    super.dispose();
    _userStreamSubscription?.cancel();
  }
}

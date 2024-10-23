import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/app_user.dart';

class AuthenticationController extends GetxController {
  AuthenticationController({GoTrueClient? authClient}) : _authClient = authClient ?? Supabase.instance.client.auth {
    _userStreamSubscription = listen();
  }

  late final GoTrueClient _authClient;
  final currentUser = Rx<AppUser?>(null);
  late final StreamSubscription<AuthState> _userStreamSubscription;

  StreamSubscription<AuthState> listen() {
    return _authClient.onAuthStateChange.listen(
      (data) {
        if (data.event != AuthChangeEvent.passwordRecovery) {
          final user = data.session?.user;
          if (user == null) {
            currentUser.value = null;
          } else {
            currentUser.value = AppUser(uid: user.id, email: user.email ?? "");
          }
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
    _userStreamSubscription.cancel();
  }
}

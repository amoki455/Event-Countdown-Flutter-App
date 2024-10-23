class AppUser {
  final String uid;
  final String email;

//<editor-fold desc="Data Methods">
  const AppUser({
    required this.uid,
    required this.email,
  });

  @override
  bool operator ==(Object other) => identical(this, other) || (other is AppUser && runtimeType == other.runtimeType && uid == other.uid && email == other.email);

  @override
  int get hashCode => uid.hashCode ^ email.hashCode;

  @override
  String toString() {
    return 'AppUser{ uid: $uid, email: $email,}';
  }

  AppUser copyWith({
    String? uid,
    String? email,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      email: map['email'] as String,
    );
  }

//</editor-fold>
}

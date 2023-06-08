abstract class AuthEvent {}

class AuthInitialEvent extends AuthEvent {}

class AuthCheckEvent extends AuthEvent {
  AuthCheckEvent({required this.email, required this.password});

  final String email;
  final String password;
}

class AuthCreateEvent extends AuthEvent {
  AuthCreateEvent(
      {required this.email, required this.password, required this.username});

  final String email;
  final String password;
  final String username;
}

class AuthCurrentUserEvent extends AuthEvent {}

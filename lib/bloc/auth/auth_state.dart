import 'package:equatable/equatable.dart';
import 'package:space_chat/bloc/models/user_model.dart';

abstract class AuthState extends Equatable {}

class AuthInitialState extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthFirebaseState extends AuthState {
  AuthFirebaseState({required this.user});

  final User user;

  User get getUser => user;

  @override
  List<Object?> get props => [user];
}

class AuthFirebaseFailure extends AuthState {
  AuthFirebaseFailure({required this.error});
  var error;

  @override
  List<Object?> get props => [error];
}

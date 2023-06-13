part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent {}

class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class SignUpEvent extends AuthenticationEvent {
  final String email;
  final String password;
  final String name;

  SignUpEvent(this.email, this.password, this.name);
}

part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class LoadingState extends AuthenticationState {}

class LoggedInState extends AuthenticationState {}

class ErrorState extends AuthenticationState {
  final String errorMessage;

  ErrorState(this.errorMessage);
}

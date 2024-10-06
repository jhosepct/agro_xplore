part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginEmailEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const AuthLoginEmailEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthLoginGoogleEvent extends AuthenticationEvent {}

class AuthAutoLoginEvent extends AuthenticationEvent {}

class AuthLogOutEvent extends AuthenticationEvent {}

part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  const AuthLoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthAutoLoginEvent extends AuthenticationEvent {}
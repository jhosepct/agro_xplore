part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationState {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {}

class AuthLoadingState extends AuthenticationState {}

class AuthErrorLoginState extends AuthenticationState {
  final String authErrorMessage;

  const AuthErrorLoginState({required this.authErrorMessage});

  @override
  List<Object> get props => [authErrorMessage];
}

class AuthLogOutState extends AuthenticationState {}

class AuthLoggedState extends AuthenticationState {
  final bool isLogged;

  const AuthLoggedState({required this.isLogged});

  @override
  List<Object> get props => [isLogged];
}
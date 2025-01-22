part of 'auth_bloc.dart';

abstract class AuthEvent {}

class StartupEvent extends AuthEvent {}

class RegisterUserEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String confirmPassword; 
  final String profileImageUrl;
  final String bio;

  RegisterUserEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword, 
    required this.profileImageUrl,
    required this.bio,
  });
}

class SignInEvent extends AuthEvent {
  final String username;
  final String password;

  SignInEvent({
    required this.username,
    required this.password,
  });
}

class SignOutEvent extends AuthEvent {}

class FetchUsersEvent extends AuthEvent {}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;

  AuthSignUpRequested(this.email, this.password);
}

class AuthCheckEmailVerified extends AuthEvent {}
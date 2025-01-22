part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class AutoLoginState extends AuthState {}

class NeedToAuthState extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorText;

  AuthErrorState({required this.errorText});
}
class UsersLoadedState extends AuthState {
  final List<AppUser> users;

   UsersLoadedState(this.users);

  List<Object> get props => [users];
}

class AuthEmailVerificationSent extends AuthState {}

class AuthEmailVerified extends AuthState {}
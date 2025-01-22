import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_template/core/user/auth_repository.dart';
import 'package:project_template/core/user/user_repository.dart';
import 'package:project_template/core/user/user_model.dart';
import 'package:uuid/uuid.dart';
import 'package:easy_localization/easy_localization.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;
  final Uuid _uuid;

  AuthBloc(this._userRepository, this._authRepository, this._uuid) : super(AuthInitial()) {
    on<StartupEvent>(_onStartupEvent);
    on<RegisterUserEvent>(_onRegisterUserEvent);
    on<SignInEvent>(_onSignInEvent);
    on<SignOutEvent>(_onSignOutEvent);
    on<FetchUsersEvent>(_onFetchUsersEvent);
    on<AuthCheckEmailVerified>(_onAuthCheckEmailVerified);
  }

  Future<void> _onStartupEvent(StartupEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    if (await _userRepository.isUserExistLocal()) {
      emit(AutoLoginState());
    } else {
      emit(NeedToAuthState());
    }
  }

  Future<void> _onRegisterUserEvent(RegisterUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      bool isUsernameTaken = await _userRepository.isUsernameTaken(event.username);
      bool isEmailTaken = await _userRepository.isEmailTaken(event.email);

      if (isUsernameTaken) {
        emit(AuthErrorState(errorText: tr('auth.username_exists')));
        return;
      }

      if (isEmailTaken) {
        emit(AuthErrorState(errorText: tr('auth.email_exists')));
        return;
      }

      // Create a temporary user object
      AppUser tempUser = AppUser(
        userId: _uuid.v4(),
        username: event.username,
        email: event.email,
        profileImageUrl: event.profileImageUrl,
        bio: event.bio,
        createdAt: DateTime.now(),
      );

      // Sign up the user and send verification email
      await _authRepository.signUpWithEmail(event.email, event.password);

      // Emit a state indicating that verification email has been sent
      emit(AuthEmailVerificationSent());

      // Start checking for email verification
      bool isEmailVerified = false;
      while (!isEmailVerified) {
        await Future.delayed(const Duration(seconds: 5));
        isEmailVerified = await _authRepository.isEmailVerified();
        if (isEmailVerified) {
          // If email is verified, sign in the user
          await _authRepository.signInWithEmail(event.email, event.password);
          
          // Now add the user to Firestore
          await _userRepository.addUserRemote(tempUser);
          emit(AutoLoginState());
        }
      }
    } catch (e) {
      emit(AuthErrorState(errorText: tr('auth.registration_error', args: [e.toString()])));
    }
  }

  Future<void> _onSignInEvent(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      String? email = await _userRepository.getEmailByUsername(event.username);

      if (email != null) {
        try {
          await _authRepository.signInWithEmail(email, event.password);

          if (await _userRepository.isUserExistRemote(event.username, email)) {
            final user = await _userRepository.getUserRemote(event.username, email);
            await _userRepository.addUserLocal(user);
            emit(AutoLoginState());
          } else {
            emit(AuthErrorState(errorText: tr('auth.user_not_exist')));
          }
        } catch (e) {
          emit(AuthErrorState(errorText: tr('auth.incorrect_credentials')));
        }
      } else {
        emit(AuthErrorState(errorText: tr('auth.username_not_found')));
      }
    } catch (e) {
      emit(AuthErrorState(errorText: tr('auth.sign_in_error', args: [e.toString()])));
    }
  }

  Future<void> _onSignOutEvent(SignOutEvent event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
    await _userRepository.removeUserLocal();
    emit(NeedToAuthState());
  }

  Future<void> _onFetchUsersEvent(FetchUsersEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final users = await _userRepository.getAllUsers();
      emit(UsersLoadedState(users));
    } catch (e) {
      emit(AuthErrorState(errorText: tr('auth.fetch_users_error', args: [e.toString()])));
    }
  }

  Future<void> _onAuthCheckEmailVerified(AuthCheckEmailVerified event, Emitter<AuthState> emit) async {
    try {
      final isVerified = await _authRepository.isEmailVerified();
      if (isVerified) {
        emit(AuthEmailVerified());
      } else {
        emit(AuthErrorState(errorText: tr('auth.email_not_verified')));
      }
    } catch (e) {
      emit(AuthErrorState(errorText: tr('auth.verification_check_error', args: [e.toString()])));
    }
  }

  Future<bool> isEmailVerified() async {
    return await _authRepository.isEmailVerified();
  }

  Future<void> sendEmailVerification() async {
    User? user = _authRepository.currentUser;
    if (user != null) {
      await _authRepository.sendEmailVerification();
    }
  }
}
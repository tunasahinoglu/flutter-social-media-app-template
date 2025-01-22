import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_template/core/user/user_repository.dart';
import 'package:project_template/scenes/auth/entry_page.dart';
import 'package:project_template/scenes/auth/login/login_page.dart';
import 'package:project_template/scenes/auth/register/register_page.dart';
import 'package:project_template/scenes/auth/reset_password/reset_password_screen.dart';
import 'package:project_template/scenes/home/home_page.dart';
import 'package:project_template/scenes/navigation/nav_screen.dart';
import 'package:project_template/scenes/onboarding/onboarding_screen.dart';
import 'package:project_template/scenes/profile/edit_profile_page.dart';
import 'package:project_template/scenes/profile/profile_page.dart';
import 'package:project_template/scenes/settings/setting_page.dart';
import 'package:project_template/scenes/splash/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/entry',
      builder: (context, state) => const EntryPage(),
    ),
    
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnboardingScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/nav',
      builder: (context, state) => const NavScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        final scrollController = ScrollController();
        return HomePage(scrollController: scrollController);
      },
    ),
    GoRoute(
      path: '/profile/:username',
      builder: (context, state) {
        final userRepository = context.read<UserRepository>();
        final username = state.pathParameters['username'] ?? ''; 
        return ProfilePage(
          userRepository: userRepository,
          username: username, 
        );
      },
      
    ),GoRoute(
  path: '/edit_profile',
  builder: (context, state) {
    final userRepository = context.read<UserRepository>();
    return EditProfilePage(userRepository: userRepository);
  },
),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),GoRoute(
      path: '/reset_password',
      builder: (context, state) => const PasswordResetScreen(),
    ),
  ],
);
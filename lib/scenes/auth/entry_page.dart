import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_template/constants/colors/colors.dart';
import 'package:project_template/scenes/auth/auth_bloc/auth_bloc.dart';
import 'package:project_template/scenes/connectivity/connectivity_bloc/connectivity_bloc.dart';
import 'package:project_template/scenes/connectivity/no_connection_page.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  Widget _child = Container(
    color: AppColors.primaryColor,
    child: const Center(
      child: CircularProgressIndicator(
        color: AppColors.secondaryColor,
      ),
    ),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(StartupEvent());
      context.read<ConnectivityBloc>().add(StartupConnectionCheck());
      _checkInitialStates();
    });
  }

  void _checkInitialStates() {
    final authState = context.read<AuthBloc>().state;
    final connectivityState = context.read<ConnectivityBloc>().state;
    
    print('Initial AuthState: $authState');
    print('Initial ConnectivityState: $connectivityState');

    if (connectivityState is NoConnectionState) {
      _updateChild(const NoConnectionPage());
    } else if (authState is AuthLoadingState) {
      _showLoading();
    } else {
      _handleAuthState(authState);
    }
  }

  void _handleAuthState(AuthState state) {
    print('Handling AuthState: $state');
    if (state is AutoLoginState) {
      print('AuthState is AutoLoginState');
      Future.microtask(() => context.go('/nav'));
    } else if (state is NeedToAuthState || state is AuthErrorState) {
      print('AuthState is NeedToAuthState or AuthErrorState');
      Future.microtask(() => context.go('/register'));
    }
  }

  void _showLoading() {
    _updateChild(Container(
      color: AppColors.primaryColor,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.secondaryColor,
        ),
      ),
    ));
  }

  void _updateChild(Widget newChild) {
    setState(() {
      _child = newChild;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ConnectivityBloc, ConnectivityState>(
          listener: (context, state) {
            print('BlocListener ConnectivityState: $state');
            if (state is NoConnectionState) {
              _updateChild(const NoConnectionPage());
            } else if (state is HasConnectionState && state.needToBlock) {
              _checkInitialStates();
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            print('BlocListener AuthState: $state');
            _handleAuthState(state);
          },
        ),
      ],
      child: Scaffold(
        body: AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          child: _child,
        ),
      ),
    );
  }
}
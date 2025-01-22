import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:project_template/core/localization/localization_bloc/localization_bloc.dart';
import 'package:project_template/router/router.dart';
import 'package:project_template/scenes/auth/auth_bloc/auth_bloc.dart';
import 'package:project_template/scenes/connectivity/connectivity_bloc/connectivity_bloc.dart';
import 'package:project_template/scenes/navigation/nav_bloc/nav_bloc.dart';
import 'package:project_template/scenes/theme/theme_bloc/theme_bloc.dart';
import 'package:project_template/core/user/auth_repository.dart';
import 'package:project_template/core/user/user_repository.dart';
import 'package:uuid/uuid.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<String> settingsBox = Hive.box<String>('settings');

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ConnectivityBloc>(
            create: (context) => ConnectivityBloc()..add(StartupConnectionCheck()),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              context.read<UserRepository>(),
              context.read<AuthRepository>(),
              const Uuid(),
            ),
          ),
          BlocProvider<NavBloc>(
            create: (context) => NavBloc(),
          ),
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(settingsBox),
          ),
          BlocProvider<LocalizationBloc>(
            create: (context) => LocalizationBloc(settingsBox),
          ),
        ],
        child: BlocBuilder<LocalizationBloc, LocalizationState>(
          builder: (context, localizationState) {
            return BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                final isDarkMode = themeState is ThemeChangedState && themeState.theme == 'dark';
                final locale = localizationState is LocalizationChangedState
                    ? localizationState.locale
                    : context.locale;

                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  routerConfig: appRouter,
                  title: 'Template',
                  theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: locale,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
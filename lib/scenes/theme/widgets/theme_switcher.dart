import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_template/scenes/theme/theme_bloc/theme_bloc.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final isDarkTheme = state is ThemeChangedState && state.theme == 'dark';

        return IconButton(
          icon: Icon(
            isDarkTheme ? Icons.light_mode : Icons.dark_mode,
            color: isDarkTheme ? Colors.blue : Colors.grey,
          ),
          onPressed: () {
            // Toggle theme 
            final newTheme = isDarkTheme ? 'light' : 'dark';
            context.read<ThemeBloc>().add(ThemeChangedEvent(newTheme));
          },
          tooltip: isDarkTheme ? 'Light Theme' : 'Dark Theme',
        );
      },
    );
  }
}
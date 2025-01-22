import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_template/constants/text_styles/text_styles.dart';
import 'package:project_template/core/localization/widget/language_switcher.dart';
import 'package:project_template/scenes/auth/auth_bloc/auth_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(tr("settings.settings"), style: AppTextStyles.body),
        leading: IconButton(
          onPressed: () => context.go('/nav'),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             ListTile(
              title: Text(
               tr("settings.language"),
                style: AppTextStyles.body,
              ),
              trailing: LanguageSwitcher(),
            ),
            const Divider(),
            ListTile(
              title: Text(
               tr("settings.change_password"),
                style: AppTextStyles.body,
              ),
              trailing: IconButton(onPressed: (){context.push('/reset_password');}, icon: Icon(Icons.password)),
            ),
            const Divider(),
            ListTile(
              title: Text(
                tr("settings.logout"),
                style: AppTextStyles.body.copyWith(
                  color: Colors.red,
                ),
              ),
              leading: const Icon(Icons.logout, color: Colors.red),
              onTap: () {
                context.read<AuthBloc>().add(SignOutEvent());
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

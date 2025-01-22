import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_template/constants/text_styles/text_styles.dart';
import 'package:project_template/core/localization/localization_bloc/localization_bloc.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocalizationBloc, LocalizationState>(
      builder: (context, state) {
        if (state is! LocalizationChangedState) {
          return const SizedBox.shrink();
        }

        final buttonText = (state.locale.languageCode == 'en') ? 'English' : 'Türkçe';

        return TextButton(
          onPressed: () {
            final newLocale = (state.locale.languageCode == 'en')
                ? const Locale('tr')
                : const Locale('en');
            context.read<LocalizationBloc>().changeLocale(context, newLocale);
          },
          child: Text(buttonText, style: AppTextStyles.body),
        );
      },
    );
  }
}
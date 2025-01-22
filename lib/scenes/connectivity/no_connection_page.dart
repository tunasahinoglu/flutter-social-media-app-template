import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:project_template/constants/text_styles/text_styles.dart';

class NoConnectionPage extends StatelessWidget {
  const NoConnectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Text(
          tr("connection.no_connection"),
          style: AppTextStyles.headline,
        ),
      ),
    );
  }
}

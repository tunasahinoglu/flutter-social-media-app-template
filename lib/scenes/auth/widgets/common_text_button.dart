import 'package:flutter/material.dart';
import 'package:project_template/constants/text_styles/text_styles.dart';

class CommonTextButtonWidget extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final String text;
  final Future<void> Function() onTap;

  const CommonTextButtonWidget(
      {super.key,
      required this.margin,
      required this.text,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
        onTap: onTap,
        child: Container(
            margin: margin,
            height: MediaQuery.of(context).size.height / 15,
            width: MediaQuery.of(context).size.width / 1,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Center(child: Text(text, style: AppTextStyles.body))));
  }
}

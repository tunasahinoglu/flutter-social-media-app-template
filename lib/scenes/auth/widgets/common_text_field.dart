import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:project_template/constants/text_styles/text_styles.dart';

class CommonTextFieldWidget extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool isSuffixIcon;
  final TextInputType keyboard;
  final String? Function(String?)? validator;

  const CommonTextFieldWidget({
    super.key,
    required this.labelText,
    required this.controller,
    required this.isSuffixIcon,
    required this.keyboard,
    this.validator,
  });

  @override
  State<CommonTextFieldWidget> createState() => _CommonTextFieldWidgetState();
}

class _CommonTextFieldWidgetState extends State<CommonTextFieldWidget> {
  bool get isObscure => widget.isSuffixIcon;
  IconData visibilityIcon = Icons.visibility_off;
  bool visibility = true;

  Widget? _suffixIcon() {
    if (widget.isSuffixIcon) {
      return InkResponse(
        radius: 25,
        child: Icon(visibilityIcon, color: Colors.blue),
        onTap: () {
          setState(() {
            visibility = !visibility;
            visibilityIcon =
                visibility ? Icons.visibility_off : Icons.visibility;
          });
        },
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: TextFormField(
        validator: widget.validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return tr("auth.fill_the_fields");
              }
              return null;
            },
        obscureText: isObscure ? visibility : isObscure,
        decoration: InputDecoration(
          suffixIcon: _suffixIcon(),
          labelText: widget.labelText,
          labelStyle: AppTextStyles.body,
          errorStyle: const TextStyle(
            color: Colors.red,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2.0,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        ),
        controller: widget.controller,
        style: AppTextStyles.body,
        keyboardType: widget.keyboard,
      ),
    );
  }
}

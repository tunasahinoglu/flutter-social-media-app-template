import 'package:easy_localization/easy_localization.dart';

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return tr("auth.enter_email");
  }
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  if (!emailRegExp.hasMatch(value)) {
    return tr("auth.enter_valid_email");
  }
  return null;
}
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_template/constants/text_styles/text_styles.dart';
import 'package:project_template/scenes/auth/auth_bloc/auth_bloc.dart';
import 'package:project_template/scenes/auth/widgets/common_text_button.dart';
import 'package:project_template/scenes/auth/widgets/common_text_field.dart';

class LoginPage extends StatefulWidget {
  final String? errorText;

  const LoginPage({Key? key, this.errorText}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text, style: AppTextStyles.body)));
  }

  Future<void> onTapLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(SignInEvent(
            username: usernameController.text,
            password: passwordController.text,
          ));
    } else {
      _showSnackBar(tr("auth.error_in_form"));
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DraggableScrollableSheet(
        builder: (BuildContext context, ScrollController scrollController) {
          return BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              if (state is AuthLoadingState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text(tr("auth.loading"), style: AppTextStyles.body)));
              } else if (state is AuthErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(state.errorText, style: AppTextStyles.body)));
              } else if (state is AutoLoginState) {
                context.go('/nav');
              }
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Text(tr("auth.sign_in_to_account"),
                            style: AppTextStyles.body),
                      ),
                      CommonTextFieldWidget(
                        labelText: tr("auth.username"),
                        controller: usernameController,
                        keyboard: TextInputType.text,
                        isSuffixIcon: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return tr("auth.enter_username");
                          }
                          return null;
                        },
                      ),
                      CommonTextFieldWidget(
                        labelText: tr("auth.password"),
                        controller: passwordController,
                        keyboard: TextInputType.text,
                        isSuffixIcon: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return tr("auth.enter_password");
                          }
                          return null;
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () {
                              context.push('/reset_password');
                            },
                            child: Text(tr("auth.forgot_password"))),
                      ),
                      const SizedBox(height: 40),
                      CommonTextButtonWidget(
                          margin: const EdgeInsets.only(bottom: 40),
                          text: tr("auth.sign_in"),
                          onTap: onTapLogin),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tr("auth.dont_have_an_account"),
                            style: AppTextStyles.body,
                          ),
                          TextButton(
                              onPressed: () => context.go('/register'),
                              child: Text(
                                tr("auth.register"),
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                    wordSpacing: 1.0,
                                    fontFamily: 'Montserrat',
                                    color: Colors.blue),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        initialChildSize: 1,
      ),
    );
  }
}

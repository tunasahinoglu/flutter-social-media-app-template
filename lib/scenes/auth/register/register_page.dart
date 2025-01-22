import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:project_template/constants/text_styles/text_styles.dart';
import 'package:project_template/scenes/auth/auth_bloc/auth_bloc.dart';
import 'package:project_template/scenes/auth/widgets/bottom_sheet_anchor.dart';
import 'package:project_template/scenes/auth/widgets/common_text_button.dart';
import 'package:project_template/scenes/auth/widgets/common_text_field.dart';

class RegisterPage extends StatefulWidget {
  final String? errorText;

  const RegisterPage({Key? key, this.errorText}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isEmailSent = false;
  bool _emailSentSuccessfully = true;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text, style: AppTextStyles.body)),
    );
  }

  Future<void> onTapRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        RegisterUserEvent(
          username: usernameController.text,
          email: emailController.text,
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text,
          profileImageUrl: '',
          bio: '',
        ),
      );
      setState(() {
        _isEmailSent = true;
        _emailSentSuccessfully = true;
      });
      _startEmailVerificationCheck();
    } else {
      _showSnackBar(tr("auth.error_in_form"));
    }
  }

  Future<void> _startEmailVerificationCheck() async {
  setState(() {
  });

  try {
    while (!(await context.read<AuthBloc>().isEmailVerified())) {
      if (!_emailSentSuccessfully) break;
      await Future.delayed(const Duration(seconds: 3));
    }

    if (await context.read<AuthBloc>().isEmailVerified()) {
      context.go('/onboarding');
    } else {
      setState(() {
        _emailSentSuccessfully = false;
      });
    }
  } catch (e) {
    setState(() {
      _emailSentSuccessfully = false;
    });
    _showSnackBar(tr("auth.verification_check_error", args: [e.toString()]));
  } finally {
    setState(() {
    });
  }
}

  Future<void> _resendVerificationEmail() async {
    try {
      await context.read<AuthBloc>().sendEmailVerification();
      setState(() {
        _emailSentSuccessfully = true;
        _isEmailSent = true;
      });
      _showSnackBar(tr("auth.verification_email_sent"));
      _startEmailVerificationCheck();
    } catch (e) {
      _showSnackBar(tr("auth.error_sending_verification", args: [e.toString()]));
    }
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(tr("auth.loading"), style: AppTextStyles.body),
                  ),
                );
              } else if (state is AuthErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(state.errorText, style: AppTextStyles.body),
                  ),
                );
              } else if (state is AuthEmailVerificationSent) {
                _showSnackBar(tr("auth.verification_email_sent"));
              } else if (state is AutoLoginState) {
                context.go('/onboarding');
              }
            },
            child: SafeArea(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const ScrollIndicator(
                          margin: EdgeInsets.only(
                            left: 140,
                            right: 140,
                            bottom: 10,
                            top: 10,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20, top: 20),
                          child: Text(
                            tr("auth.create_account"),
                            style: AppTextStyles.body,
                          ),
                        ),
                        CommonTextFieldWidget(
                          labelText: tr("auth.username"),
                          controller: usernameController,
                          keyboard: TextInputType.text,
                          isSuffixIcon: false,
                        ),
                        CommonTextFieldWidget(
                          labelText: tr("auth.email"),
                          controller: emailController,
                          keyboard: TextInputType.emailAddress,
                          isSuffixIcon: false,
                        ),
                        CommonTextFieldWidget(
                          labelText: tr("auth.password"),
                          controller: passwordController,
                          keyboard: TextInputType.text,
                          isSuffixIcon: true,
                        ),
                        CommonTextFieldWidget(
                          labelText: tr("auth.confirm_password"),
                          controller: confirmPasswordController,
                          keyboard: TextInputType.text,
                          isSuffixIcon: true,
                        ),
                        const SizedBox(height: 40),
                        CommonTextButtonWidget(
                          margin: const EdgeInsets.only(bottom: 40),
                          text: tr("auth.register"),
                          onTap: onTapRegister,
                        ),
                    
                        if (_isEmailSent && !_emailSentSuccessfully)
                          Column(
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                tr("auth.verification_email_not_received"),
                                style: AppTextStyles.body,
                              ),
                              const SizedBox(height: 10),
                              CommonTextButtonWidget(
                                margin: const EdgeInsets.only(bottom: 40),
                                text: tr("auth.resend_verification_email"),
                                onTap: _resendVerificationEmail,
                              ),
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tr("auth.already_have_an_account"),
                              style: AppTextStyles.body,
                            ),
                            TextButton(
                              onPressed: () => context.go('/login'),
                              child: Text(
                                tr("auth.sign_in"),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                  wordSpacing: 1.0,
                                  fontFamily: 'Montserrat',
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
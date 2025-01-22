import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConfirmResetPasswordScreen extends StatefulWidget {
  @override
  _ConfirmResetPasswordScreenState createState() => _ConfirmResetPasswordScreenState();
}

class _ConfirmResetPasswordScreenState extends State<ConfirmResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _message = '';
  String? _oobCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _oobCode = ModalRoute.of(context)?.settings.arguments as String?;
  }

  Future<void> _confirmResetPassword() async {
    if (_oobCode == null) {
      setState(() {
        _message = 'Invalid code. Please request a new password reset.';
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _message = 'Passwords do not match.';
      });
      return;
    }

    try {
      await _auth.confirmPasswordReset(
        code: _oobCode!,
        newPassword: _passwordController.text,
      );
      setState(() {
        _message = 'Password has been reset!';
      });
    } catch (e) {
      setState(() {
        _message = 'Failed to reset password: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Reset Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmResetPassword,
              child: Text('Reset Password'),
            ),
            SizedBox(height: 20),
            Text(_message),
          ],
        ),
      ),
    );
  }
}
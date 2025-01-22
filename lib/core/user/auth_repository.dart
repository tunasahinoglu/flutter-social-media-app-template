import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  static final AuthRepository _authRepository = AuthRepository._internal();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Timer? _deletionTimer;

  factory AuthRepository() {
    return _authRepository;
  }

  AuthRepository._internal();

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        _startDeletionTimer(user);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Registration failed: ${e.message}');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  void _startDeletionTimer(User user) {
    _deletionTimer?.cancel();
    _deletionTimer = Timer(const Duration(minutes: 2), () async {
      await user.reload();
      if (!user.emailVerified) {
        await user.delete();
      }
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = _firebaseAuth.currentUser;
      if (user != null && !user.emailVerified) {
        _startDeletionTimer(user);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception(
            'Bu e-posta için kullanıcı bulunamadı. Lütfen e-posta adresinizi kontrol edin veya kaydolun.');
      } else if (e.code == 'wrong-password') {
        throw Exception(
            'Yanlış şifre. Lütfen şifrenizi kontrol edin ve tekrar deneyin.');
      } else {
        throw Exception('Giriş başarısız: ${e.message}');
      }
    } catch (e) {
      throw Exception('Beklenmeyen bir hata oluştu: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      _deletionTimer?.cancel();
    } catch (e) {
      throw Exception('Oturum kapatma başarısız: ${e.toString()}');
    }
  }

  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        _startDeletionTimer(user);
      } catch (e) {
        throw Exception('E-posta doğrulama gönderilemedi: ${e.toString()}');
      }
    }
  }

  Future<bool> isEmailVerified() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.reload();
      if (user.emailVerified) {
        _deletionTimer?.cancel();
      }
      return user.emailVerified;
    }
    return false;
  }
}

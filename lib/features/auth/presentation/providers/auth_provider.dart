// Sesuai modul hal.23-27 — LENGKAP
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/services/dio_client.dart';
import '../../../../core/services/secure_storage.dart';
import '../../../../core/constants/api_constants.dart';

// Sesuai modul hal.23 — enum AuthStatus
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  emailNotVerified,
  error,
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn();

  // ── State ──────────────────────────────────────────────
  AuthStatus _status = AuthStatus.initial;
  User? _firebaseUser;
  String? _backendToken;
  String? _errorMessage;
  String? _tempEmail;
  String? _tempPassword;

  // ── Getters ────────────────────────────────────────────
  AuthStatus get status => _status;
  User? get firebaseUser => _firebaseUser;
  String? get backendToken => _backendToken;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;

  // ── Register (sesuai modul hal.24) ────────────────────
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseUser = credential.user;
      await _firebaseUser?.updateDisplayName(name);
      await _firebaseUser?.sendEmailVerification();
      _tempEmail = email;
      _tempPassword = password;
      _status = AuthStatus.emailNotVerified;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      return false;
    } catch (e) {
      _setError('Terjadi kesalahan. Coba lagi.');
      return false;
    }
  }

  // ── Login Email (sesuai modul hal.25) ─────────────────
  Future<bool> loginWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseUser = credential.user;
      if (!(_firebaseUser?.emailVerified ?? false)) {
        _status = AuthStatus.emailNotVerified;
        notifyListeners();
        return false;
      }
      return await _verifyTokenToBackend();
    } on FirebaseAuthException catch (e) {
      _setError(_mapFirebaseError(e.code));
      return false;
    }
  }

  // ── Login Google (sesuai modul hal.26) ────────────────
  Future<bool> loginWithGoogle() async {
    _setLoading();
    try {
      final googleUser = await _google.signIn();
      if (googleUser == null) {
        _setError('Login Google dibatalkan');
        return false;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCred = await _auth.signInWithCredential(credential);
      _firebaseUser = userCred.user;
      return await _verifyTokenToBackend();
    } catch (e) {
      _setError('Gagal login dengan Google');
      return false;
    }
  }

  // ── Cek email verified (polling) (sesuai modul hal.26) ─
  Future<bool> checkEmailVerified() async {
    await _firebaseUser?.reload();
    _firebaseUser = _auth.currentUser;
    if (_firebaseUser?.emailVerified ?? false) {
      return await _loginAfterVerification();
    }
    return false;
  }

  Future<bool> _loginAfterVerification() async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: _tempEmail!,
        password: _tempPassword!,
      );
      _firebaseUser = credential.user;
      _tempEmail = null;
      _tempPassword = null;
      return await _verifyTokenToBackend();
    } catch (e) {
      _setError('Gagal login setelah verifikasi');
      return false;
    }
  }

  // ── Resend email (sesuai modul hal.26) ────────────────
  Future<void> resendVerificationEmail() async {
    await _firebaseUser?.sendEmailVerification();
  }

  // ── Verify token ke backend (sesuai modul hal.25) ─────
  Future<bool> _verifyTokenToBackend() async {
    try {
      final firebaseToken = await _firebaseUser?.getIdToken();
      final response = await DioClient.instance.post(
        ApiConstants.verifyToken,
        data: {'firebase_token': firebaseToken},
      );
      final data = response.data['data'] as Map<String, dynamic>;
      final token = data['access_token'] as String;
      await SecureStorageService.saveToken(token);
      _backendToken = token;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Gagal verifikasi ke server');
      return false;
    }
  }

  // ── Logout (sesuai modul hal.26) ──────────────────────
  Future<void> logout() async {
    await _auth.signOut();
    await _google.signOut();
    await SecureStorageService.clearAll();
    _firebaseUser = null;
    _backendToken = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  // ── Private Helpers (sesuai modul hal.27) ─────────────
  void _setLoading() {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setError(String message) {
    _status = AuthStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  String _mapFirebaseError(String code) => switch (code) {
    'email-already-in-use' => 'Email sudah terdaftar.',
    'user-not-found' => 'Akun tidak ditemukan.',
    'wrong-password' => 'Password salah.',
    'invalid-email' => 'Format email tidak valid.',
    'weak-password' => 'Password terlalu lemah.',
    'network-request-failed' => 'Tidak ada koneksi internet.',
    'invalid-credential' => 'Email atau password salah.',
    _ => 'Terjadi kesalahan. Coba lagi.',
  };
}

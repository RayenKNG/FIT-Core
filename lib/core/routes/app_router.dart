// Sesuai modul hal.45-46
import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static const String splash     = '/';
  static const String login      = '/login';
  static const String register   = '/register';
  static const String verifyEmail= '/verify-email';
  static const String dashboard  = '/dashboard';

  static Map<String, WidgetBuilder> get routes => {
    splash:      (_) => const SplashPage(),
    login:       (_) => const LoginPage(),
    register:    (_) => const RegisterPage(),
    verifyEmail: (_) => const VerifyEmailPage(),
    dashboard:   (_) => const AuthGuard(child: DashboardPage()),
  };
}

// Auth Guard (sesuai modul hal.45)
class AuthGuard extends StatelessWidget {
  final Widget child;
  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final status = context.watch<AuthProvider>().status;
    return switch (status) {
      AuthStatus.authenticated     => child,
      AuthStatus.emailNotVerified  => const VerifyEmailPage(),
      _                            => const LoginPage(),
    };
  }
}

// Splash Page (sesuai modul hal.46)
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Animasi splash 2 detik
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Cek token tersimpan
    final token = await SecureStorageService.getToken();
    final route = token != null
        ? AppRouter.dashboard
        : AppRouter.login;
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animasi splash
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: AppColors.primaryGradient,
              ).createShader(bounds),
              child: const Text(
                'FIT⚡CORE',
                style: TextStyle(
                  fontSize:   40,
                  fontWeight: FontWeight.w900,
                  color:      Colors.white,
                  letterSpacing: -1,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Train Like A Beast.',
              style: TextStyle(
                color:    AppColors.textMuted,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Import yang dibutuhkan SplashPage
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../constants/app_colors.dart';
import '../services/secure_storage.dart';
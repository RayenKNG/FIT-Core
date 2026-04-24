// Sesuai modul hal.11 & 40-41
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/dashboard/presentation/providers/product_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase (sesuai modul hal.11)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const FitcoreApp());
}

class FitcoreApp extends StatelessWidget {
  const FitcoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider (sesuai modul hal.40-41)
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'FITCORE',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        initialRoute: AppRouter.splash,
        routes: AppRouter.routes,
      ),
    );
  }
}

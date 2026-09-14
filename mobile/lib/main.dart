import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/farmly_providers.dart';
import 'features/onboarding/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FarmlyDataProvider()),
      ],
      child: const FarmlyApp(),
    ),
  );
}

class FarmlyApp extends StatelessWidget {
  const FarmlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farmly',
      debugShowCheckedModeBanner: false,
      theme: FarmlyTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

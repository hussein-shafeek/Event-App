import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/theme/app_theme.dart';
import 'package:evently/features/auth/ui/login_screen.dart';
import 'package:evently/features/auth/ui/register_screen.dart';
import 'package:evently/features/home/ui/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(EventlyApp());
}

class EventlyApp extends StatelessWidget {
  const EventlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.loginScreen,
      darkTheme: AppTheme.CustomeDarkTheme,
      theme: AppTheme.CustomeLightTheme,
      themeMode: ThemeMode.light,
      routes: {
        AppRoutes.homeScreen: (_) => HomeScreen(),
        AppRoutes.loginScreen: (_) => LoginScreen(),
        AppRoutes.registerScreen: (_) => RegisterScreen(),
      },
    );
  }
}

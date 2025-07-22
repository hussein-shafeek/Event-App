import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/theme/app_theme.dart';
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
      initialRoute: AppRoutes.homeScreen,
      darkTheme: AppTheme.CustomeDarkTheme,
      themeMode: ThemeMode.dark,
      routes: {AppRoutes.homeScreen: (_) => HomeScreen()},
    );
  }
}

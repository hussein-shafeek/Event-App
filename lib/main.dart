import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/theme/app_theme.dart';
import 'package:evently/features/auth/ui/login_screen.dart';
import 'package:evently/features/auth/ui/register_screen.dart';
import 'package:evently/features/events/ui/create_event/create_event_screen.dart';
import 'package:evently/features/home/ui/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      theme: AppTheme.CustomeLightTheme,
      themeMode: ThemeMode.light,
      routes: {
        AppRoutes.homeScreen: (_) => HomeScreen(),
        AppRoutes.loginScreen: (_) => LoginScreen(),
        AppRoutes.registerScreen: (_) => RegisterScreen(),
        AppRoutes.createEvent: (_) => CreateEventScreen(),
      },
    );
  }
}

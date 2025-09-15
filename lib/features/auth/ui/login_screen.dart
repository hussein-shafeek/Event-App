import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/core/utils/default_elevated_button.dart';
import 'package:evently/core/utils/default_text_form_field.dart';
import 'package:evently/features/auth/logic/login_logic.dart';
import 'package:evently/features/home/ui/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    TextTheme text = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.fill,
              height: height * 0.2,
            ),
            SizedBox(height: 24),
            DefaultTextFormField(
              hintText: 'Email',
              controller: emailController,
              prefixIconImageName: 'Email',
            ),
            SizedBox(height: 16),
            DefaultTextFormField(
              hintText: 'Password',
              controller: passwordController,
              prefixIconImageName: 'lock',
            ),
            SizedBox(height: 24),
            DefaultElevatedButton(label: 'Login', onPressed: login),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don’t Have Account ?', style: text.titleMedium),
                TextButton(
                  onPressed:
                      () => Navigator.of(
                        context,
                      ).pushReplacementNamed(AppRoutes.registerScreen),
                  child: Text('Create Account'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void login() {
    FireBaseService.login(
      email: emailController.text,
      password: passwordController.text,
    ).then((user) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);
    });
  }
}

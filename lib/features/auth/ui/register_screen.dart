import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/core/utils/default_elevated_button.dart';
import 'package:evently/core/utils/default_text_form_field.dart';
import 'package:evently/features/auth/logic/register_logic.dart';
import 'package:evently/features/home/ui/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
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
              hintText: 'Name',
              controller: nameController,
              prefixIconImageName: 'person',
            ),
            SizedBox(height: 16),
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
            DefaultElevatedButton(label: 'Create Account', onPressed: register),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already Have Account ?', style: text.titleMedium),
                TextButton(
                  onPressed:
                      () => Navigator.of(
                        context,
                      ).pushReplacementNamed(AppRoutes.loginScreen),
                  child: Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void register() {
    FireBaseService.register(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    ).then((user) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);
    });
  }
}

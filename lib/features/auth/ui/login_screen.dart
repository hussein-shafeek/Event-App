import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/core/utils/default_elevated_button.dart';
import 'package:evently/core/utils/default_text_form_field.dart';
import 'package:evently/features/auth/data/ui_utils.dart';
import 'package:evently/features/auth/logic/login_logic.dart';
import 'package:evently/features/home/ui/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.of(context).size.height;
    TextTheme text = Theme.of(context).textTheme;
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: SizedBox(
              height: height - MediaQuery.of(context).padding.top,
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
                    validator: (value) {
                      if (value == null || value.length < 5) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DefaultTextFormField(
                    hintText: 'Password',
                    isPassword: true,
                    controller: passwordController,
                    prefixIconImageName: 'lock',
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
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
          ),
        ),
      ),
    );
  }

  void login() {
    if (formKey.currentState!.validate()) {
      FireBaseService.login(
            email: emailController.text,
            password: passwordController.text,
          )
          .then((user) {
            Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);
            // لعرض رسالة نجاح بعد تسجيل الدخول
            UIUtils.showSuccessMessage(context, 'Login successful!');
          })
          .catchError((error) {
            String? errorMessage;
            if (error is FirebaseAuthException) {
              errorMessage = error.message;
            }
            // تمرير الـ context إلى دالة رسالة الخطأ
            UIUtils.showErrorMessage(context, errorMessage);
          });
    }
  }
}

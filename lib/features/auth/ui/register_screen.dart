import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/core/utils/default_elevated_button.dart';
import 'package:evently/core/utils/default_text_form_field.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
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
                  const SizedBox(height: 24),
                  DefaultTextFormField(
                    hintText: 'Name',
                    controller: nameController,
                    prefixIconImageName: 'person',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DefaultTextFormField(
                    hintText: 'Email',
                    controller: emailController,
                    prefixIconImageName: 'Email',
                    validator: (value) {
                      if (value == null || value.length < 5) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 24),
                  DefaultElevatedButton(
                    label: 'Create Account',
                    onPressed: register,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already Have Account ?', style: text.titleMedium),
                      TextButton(
                        onPressed:
                            () => Navigator.of(
                              context,
                            ).pushReplacementNamed(AppRoutes.loginScreen),
                        child: const Text('Login'),
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

  void register() {
    if (formKey.currentState!.validate()) {
      FireBaseService.register(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      ).then((user) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);
      });
    }
  }
}

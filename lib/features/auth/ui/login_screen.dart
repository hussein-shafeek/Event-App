import 'package:evently/core/models/user_model.dart';
import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/providers/user_provider.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/core/utils/default_elevated_button.dart';
import 'package:evently/core/utils/default_text_form_field.dart';
import 'package:evently/core/utils/dialog_custom.dart';
import 'package:evently/features/auth/data/ui_utils.dart';
import 'package:evently/features/auth/logic/login_logic.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    double height = MediaQuery.of(context).size.height;
    TextTheme text = Theme.of(context).textTheme;
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  SizedBox(height: height * 0.027241),
                  DefaultTextFormField(
                    hintText: t.email,
                    controller: emailController,
                    prefixIconImageName: 'Email',
                    validator: (value) {
                      if (value == null || value.length < 5) {
                        return t.somethingWrong;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.01816),
                  DefaultTextFormField(
                    hintText: t.password,
                    isPassword: true,
                    controller: passwordController,
                    prefixIconImageName: 'lock',
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return t.passwordTooShort;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.027241),
                  DefaultElevatedButton(
                    label: t.login,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        LoginLogic.login(
                          context: context,
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      }
                    },

                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                  SizedBox(height: height * 0.0227),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.noAccount,
                        style: text.titleMedium,
                      ),

                      TextButton(
                        onPressed:
                            () => Navigator.of(
                              context,
                            ).pushReplacementNamed(AppRoutes.registerScreen),
                        child: Text(t.createAccount),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.0227),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: AppColors.primary,
                          endIndent: 20,
                          indent: 20,
                        ),
                      ),
                      Text(
                        t.or,
                        style: text.titleMedium!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: AppColors.primary,
                          endIndent: 20,
                          indent: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.0227),
                  DefaultElevatedButton(
                    label: t.loginWithGoogle,
                    backgroundColor: AppColors.backgroundDark,
                    prefixSvgPath: 'assets/icons/google.svg',
                    onPressed: () => LoginLogic.loginWithGoogle(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

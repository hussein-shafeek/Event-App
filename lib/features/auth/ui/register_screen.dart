import 'package:evently/core/providers/setting_provider.dart';
import 'package:evently/core/routes/routes.dart';

import 'package:evently/core/utils/default_elevated_button.dart';
import 'package:evently/core/utils/default_text_form_field.dart';
import 'package:evently/features/auth/logic/register_logic.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final t = AppLocalizations.of(context)!;
    final settingProvider = Provider.of<SettingProvider>(context);

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
                    hintText: t.name,
                    controller: nameController,
                    prefixIconImageName: 'person',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return t.nameRequired;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.01816),
                  DefaultTextFormField(
                    hintText: t.email,
                    controller: emailController,
                    prefixIconImageName: 'Email',
                    validator: (value) {
                      if (value == null || value.length < 5) {
                        return t.emailInvalid;
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
                  SizedBox(height: height * 0.02724),
                  DefaultElevatedButton(
                    label: t.createAccount,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        RegisterLogic.register(
                          context: context,
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      }
                    },
                  ),
                  SizedBox(height: height * 0.022701),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(t.alreadyHaveAccount, style: text.titleMedium),
                      TextButton(
                        onPressed:
                            () => Navigator.of(
                              context,
                            ).pushReplacementNamed(AppRoutes.loginScreen),
                        child: Text(t.login),
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
}

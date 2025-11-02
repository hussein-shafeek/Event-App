import 'package:evently/core/providers/user_provider.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/features/auth/data/ui_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterLogic {
  static Future<void> register({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await FireBaseService.register(
        name: name,
        email: email,
        password: password,
      );

      Provider.of<UserProvider>(context, listen: false).updateCurrentUser(user);
      Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);
    } catch (error) {
      String? errorMessage;
      if (error is FirebaseAuthException) {
        errorMessage = error.message;
      }
      UIUtils.showErrorMessage(context, errorMessage);
    }
  }
}

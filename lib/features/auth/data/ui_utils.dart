import 'package:evently/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class UIUtils {
  static void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showErrorMessage(BuildContext context, String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Something went wrong'),
        backgroundColor: AppColors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}

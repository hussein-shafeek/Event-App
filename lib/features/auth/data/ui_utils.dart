import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/core/utils/localization_helper.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class UIUtils {
  static void showSuccessMessage(BuildContext context, String message) {
    final appLocalizations = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(appLocalizations.translate(message)),
        backgroundColor: AppColors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showErrorMessage(BuildContext context, String? message) {
    final appLocalizations = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message != null
              ? (appLocalizations.translate(message) ?? message)
              : appLocalizations.somethingWrong,
        ),
        backgroundColor: AppColors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}

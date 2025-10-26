import 'package:evently/core/providers/setting_provider.dart';
import 'package:evently/core/providers/user_provider.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/features/events/logic/language_model.dart';
import 'package:evently/features/events/ui/profile/profile_header.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final settingProvider = Provider.of<SettingProvider>(context);
    final text = Theme.of(context).textTheme;
    final appLocalizations = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ProfileHeader(),
        const SizedBox(height: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  تبديل الثيم
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      appLocalizations.darkTheme, // ← من ملف الترجمة
                      style: text.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            settingProvider.isDark
                                ? AppColors.white
                                : AppColors.black,
                      ),
                    ),
                    Switch(
                      value: settingProvider.isDark,
                      onChanged: (isDark) {
                        settingProvider.changeTheme(
                          isDark ? ThemeMode.dark : ThemeMode.light,
                        );
                      },
                      activeTrackColor: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // 🔹 اختيار اللغة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      appLocalizations.language, //  من ملف الترجمة
                      style: text.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            settingProvider.isDark
                                ? AppColors.white
                                : AppColors.black,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButton(
                        value: settingProvider.languageCode,
                        items:
                            LanguageModel.languages
                                .map(
                                  (language) => DropdownMenuItem(
                                    value: language.code,
                                    child: Text(
                                      language.name,
                                      style: text.titleLarge!.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (languageCode) {
                          if (languageCode == null) return;
                          settingProvider.changeLanguage(languageCode);
                        },
                        borderRadius: BorderRadius.circular(16),
                        underline: const SizedBox(),
                        iconEnabledColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                InkWell(
                  onTap: () {
                    FireBaseService.logout().then((_) {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(AppRoutes.loginScreen);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsetsDirectional.only(bottom: 35),
                    padding: const EdgeInsetsDirectional.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      textDirection:
                          isRTL ? TextDirection.rtl : TextDirection.ltr,
                      children: [
                        const Icon(
                          Icons.logout,
                          size: 24,
                          color: AppColors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(appLocalizations.logout, style: text.titleLarge),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

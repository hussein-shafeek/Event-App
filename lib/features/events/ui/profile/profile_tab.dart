import 'package:evently/core/providers/setting_provider.dart';
import 'package:evently/core/providers/user_provider.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/features/events/logic/language_model.dart';
import 'package:evently/features/events/ui/profile/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    SettingProvider settingProvider = Provider.of<SettingProvider>(context);
    TextTheme text = Theme.of(context).textTheme;
    UserProvider userProvider = Provider.of<UserProvider>(
      context,
      listen: false,
    );

    // ignore: avoid_unnecessary_containers
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileHeader(),
        SizedBox(height: 24),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dark Theme',
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
                SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Language',
                      style: text.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color:
                            settingProvider.isDark
                                ? AppColors.white
                                : AppColors.black,
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: DropdownButton(
                        value: 'En',
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
                        onChanged: (value) {},
                        borderRadius: BorderRadius.circular(16),
                        underline: SizedBox(),
                        iconEnabledColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    FireBaseService.logout().then((_) {
                      Navigator.of(
                        // ignore: use_build_context_synchronously
                        context,
                      ).pushReplacementNamed(AppRoutes.loginScreen);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 35),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 24, color: AppColors.white),
                        SizedBox(width: 8),
                        Text('Logout', style: text.titleLarge),
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

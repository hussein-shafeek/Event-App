import 'package:evently/core/providers/setting_provider.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/core/utils/default_elevated_button.dart';
import 'package:evently/features/events/logic/language_model.dart';
import 'package:evently/features/onboarding/data/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Future<void> _finishOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_shown', true);
    Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final t = AppLocalizations.of(context)!;
    final settingProvider = context.watch<SettingProvider>();
    final pages = OnboardingModel.getPages(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// ✅ الشعار بالأعلى
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/images/onboardingLogo.png',
                height: height * 0.0561,
                width: width * 0.4045,
                alignment: Alignment.topCenter,
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  final page = pages[index];

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/${page.image}.png',
                          height: height * 0.4,
                          width: width * 0.9,
                        ),
                        SizedBox(height: height * 0.035),

                        Text(
                          page.title,
                          style: text.titleLarge!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: height * 0.03),

                        Text(
                          page.description,
                          style: text.titleMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height * 0.05),

                        if (index == 0) ...[
                          SizedBox(height: height * 0.04),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                t.darkTheme,
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

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                t.language,
                                style: text.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      settingProvider.isDark
                                          ? AppColors.white
                                          : AppColors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
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
                                                style: text.titleLarge!
                                                    .copyWith(
                                                      color: AppColors.primary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (languageCode) {
                                    if (languageCode == null) return;
                                    settingProvider.changeLanguage(
                                      languageCode,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  underline: const SizedBox(),
                                  iconEnabledColor: AppColors.primary,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: height * 0.03),

                          /// 🔹 "Let's Start"
                          DefaultElevatedButton(
                            label: t.letsStart,
                            backgroundColor: AppColors.primary,
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),

            /// ✅ المؤشرات + الأسهم (شفافة)
            if (_currentPage != 0)
              Container(
                color: Colors.transparent,
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: width * 0.05,
                  vertical: height * 0.025,
                ),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// ← سهم الرجوع (من الصفحة الثانية فما فوق)
                      if (_currentPage > 0)
                        IconButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: SvgPicture.asset('assets/icons/left_arrow.svg'),
                        )
                      else
                        const SizedBox(width: 48),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 20.0 : 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color:
                                  _currentPage == index
                                      ? AppColors.primary
                                      : AppColors.gray,
                            ),
                          ),
                        ),
                      ),

                      /// → السهم اليمين
                      if (_currentPage < pages.length - 1)
                        IconButton(
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/right_arrow.svg',
                          ),
                        )
                      else
                        /// 🔹 الصفحة الأخيرة → يدخل على Login
                        IconButton(
                          onPressed: () {
                            _finishOnboarding(context);
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/right_arrow.svg',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

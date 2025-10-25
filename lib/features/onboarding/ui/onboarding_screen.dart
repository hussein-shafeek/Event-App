import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/features/onboarding/data/onboarding_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // @desc: Controller for the PageView.
  final PageController _pageController = PageController();
  // @desc: The index of the current page.
  int _currentPage = 0;
  // ✅ function to save onboarding status
  Future<void> _finishOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_shown', true); // نحفظ انه شاف الأونبوردنج

    Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme text = Theme.of(context).textTheme;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    print('Screen Width: $width pixels /n and Screen height: $height pixels');
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // @desc: Skip button positioned at the top right.
              Image.asset(
                'assets/images/onboardingLogo.png',
                height: height * 0.0561,
                width: width * 0.4045,

                alignment: Alignment.topCenter,
              ),
              SizedBox(height: height * 0.03),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: OnboardingModel.pages.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    final page = OnboardingModel.pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // @desc: Onboarding image. Using a placeholder for now.
                        Image.asset(
                          'assets/images/${page.image}.png',
                          height: height * 0.40067,
                          width: width * 0.90,
                        ),
                        SizedBox(height: height * 0.035),
                        // @desc: Onboarding title.
                        Text(
                          page.title,
                          style: text.titleLarge!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: height * 0.044267),
                        // @desc: Onboarding description.
                        Text(
                          page.description,
                          style: text.titleMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    );
                  },
                ),
              ),

              //SizedBox(height: height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // @desc: Back button visible from the second page onwards.
                  if (_currentPage > 0)
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.204),
                      child: IconButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/left_arrow.svg',
                          //colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.204),
                      child: const SizedBox(width: 48),
                    ), // Match the size of the IconButton to align correctly
                  // @desc: Page indicators in the center.
                  ...OnboardingModel.pages.asMap().entries.map((entry) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentPage == entry.key ? 20.0 : 10.0,
                      height: 10.0,
                      // margin: const EdgeInsets.symmetric(horizontal: 2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color:
                            _currentPage == entry.key
                                ? AppColors.primary
                                : AppColors.gray,
                      ),
                    );
                  }),

                  // @desc: Next button or Get Started button.
                  Padding(
                    padding: EdgeInsets.only(left: width * 0.204),
                    child: IconButton(
                      onPressed: () {
                        if (_currentPage < OnboardingModel.pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          _finishOnboarding(context);
                        }
                      },
                      icon: SvgPicture.asset('assets/icons/right_arrow.svg'),
                    ),
                  ),
                ],
              ),
            ],
          ),
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

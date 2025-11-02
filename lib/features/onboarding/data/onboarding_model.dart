import 'package:evently/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String description;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });

  static List<OnboardingModel> getPages(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return [
      OnboardingModel(
        image: 'onboarding0',
        title: t.onboarding_title_0,
        description: t.onboarding_description_0,
      ),
      OnboardingModel(
        image: 'onboarding1',
        title: t.onboardingTitle1,
        description: t.onboardingDesc1,
      ),
      OnboardingModel(
        image: 'onboarding2',
        title: t.onboardingTitle2,
        description: t.onboardingDesc2,
      ),
      OnboardingModel(
        image: 'onboarding3',
        title: t.onboardingTitle3,
        description: t.onboardingDesc3,
      ),
    ];
  }
}

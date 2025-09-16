import 'package:flutter/material.dart';

class OnboardingModel {
  // @desc: The image asset name for the onboarding page.
  final String image;
  // @desc: The title for the onboarding page.
  final String title;
  // @desc: A short description explaining the page's purpose.
  final String description;

  OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });

  // @desc: A static list containing all the onboarding pages data.
  static List<OnboardingModel> pages = [
    OnboardingModel(
      image: 'onboarding1',
      title: 'Find Events That Inspire You',
      description:
          "Dive into a world of events crafted to fit your unique interests. Whether you're into live \nmusic, art workshops, professional networking, or simply discovering new experiences, we \nhave something for everyone. Our curated recommendations will help you explore, \nconnect, and make the most of every \nopportunity around you.",
    ),
    OnboardingModel(
      image: 'onboarding2',
      title: 'Effortless Event Planning',
      description:
          'Take the hassle out of organizing events with our all-in-one planning tools. From setting up invites and managing RSVPs to scheduling reminders and coordinating details, we’ve got you covered. Plan with ease and focus on what matters – creating an unforgettable experience for you and your guests.',
    ),
    OnboardingModel(
      image: 'onboarding3',
      title: 'Connect with Friends & Share Moments',
      description:
          'Make every event memorable by sharing the experience with others. Our platform lets you invite friends, keep everyone in the loop, and celebrate moments together. Capture and share the excitement with your network, so you can relive the highlights and cherish the memories.',
    ),
  ];
}

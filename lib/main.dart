import 'package:evently/core/models/event_models.dart';
import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/providers/location_provider.dart';
import 'package:evently/core/providers/setting_provider.dart';
import 'package:evently/core/providers/user_provider.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/services/fcm_services.dart';
import 'package:evently/core/theme/app_theme.dart';
import 'package:evently/features/auth/ui/login_screen.dart';
import 'package:evently/features/auth/ui/register_screen.dart';
import 'package:evently/features/events/ui/create_event/create_event_screen.dart';
import 'package:evently/features/events/ui/details_edit_event/details_screen.dart';
import 'package:evently/features/events/ui/details_edit_event/edit_Event.dart';
import 'package:evently/features/events/ui/map/location_picker.dart';
import 'package:evently/features/home/ui/home_screen.dart';
import 'package:evently/features/onboarding/ui/onboarding_screen.dart';
import 'package:evently/firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:device_preview/device_preview.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';

// @desc: A global variable to hold the onboarding status.
bool? showOnboarding;
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FcmServices.setupFlutterNotifications();
  FcmServices.showFlutterNotification(message);
}

// @desc: The main entry point of the application.
Future<void> main() async {
  // @desc: Ensure that Flutter widgets are initialized before accessing SharedPreferences.
  WidgetsFlutterBinding.ensureInitialized();

  // @desc: Initialize Firebase.
  await Firebase.initializeApp();
  FcmServices.printDeviceToken();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FcmServices.setupFlutterNotifications();

  // @desc: Get an instance of SharedPreferences.
  final prefs = await SharedPreferences.getInstance();

  // هيتمسح بعدين
  // await prefs.remove('onboarding_shown');

  // @desc: Check if the 'onboarding_shown' key exists. If it's null (first time), it defaults to false.
  showOnboarding = prefs.getBool('onboarding_shown') ?? false;

  runApp(
    DevicePreview(
      enabled: false,
      builder:
          (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => EventsProvider()..getEvents(),
              ),
              ChangeNotifierProvider(create: (_) => UserProvider()),
              ChangeNotifierProvider(create: (_) => SettingProvider()),
              ChangeNotifierProvider(create: (context) => LocationProvider()),
            ],

            child: EventlyApp(showOnboarding: showOnboarding),
          ),
    ),
  );
}

class EventlyApp extends StatefulWidget {
  // @desc: A boolean to check if the onboarding screen has been shown.
  final bool? showOnboarding;

  const EventlyApp({super.key, this.showOnboarding});

  @override
  State<EventlyApp> createState() => _EventlyAppState();
}

class _EventlyAppState extends State<EventlyApp> {
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen(FcmServices.showFlutterNotification);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SettingProvider settingProvider = Provider.of<SettingProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // @desc: Set the initial route based on the onboarding status.
      initialRoute: // AppRoutes.onboardingScreen,
          widget.showOnboarding == true
              ? AppRoutes.loginScreen
              : AppRoutes.onboardingScreen,
      darkTheme: AppTheme.CustomeDarkTheme,
      theme: AppTheme.CustomeLightTheme,
      themeMode: settingProvider.themeMode,
      //localization
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(settingProvider.languageCode),
      routes: {
        AppRoutes.onboardingScreen: (_) => OnboardingScreen(),
        AppRoutes.homeScreen: (_) => HomeScreen(),
        AppRoutes.loginScreen: (_) => LoginScreen(),
        AppRoutes.registerScreen: (_) => RegisterScreen(),
        AppRoutes.createEvent: (_) => CreateEventScreen(),
        AppRoutes.detailsScreen: (_) => DetailsScreen(),
        AppRoutes.locationPicker: (_) => LocationPicker(),
        AppRoutes.editEvent:
            (context) => EditEventScreen(
              event: ModalRoute.of(context)!.settings.arguments as EventModel,
            ),
      },
    );
  }
}
//AIzaSyBQR7b5R9LiL9X_RPuZ1oWUxh7dH_nowtQ
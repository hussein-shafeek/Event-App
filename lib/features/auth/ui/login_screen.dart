import 'package:evently/core/models/user_model.dart';
import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/providers/user_provider.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/core/theme/app_colors.dart';
import 'package:evently/core/utils/default_elevated_button.dart';
import 'package:evently/core/utils/default_text_form_field.dart';
import 'package:evently/core/utils/dialog_custom.dart';
import 'package:evently/features/auth/data/ui_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    TextTheme text = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: SizedBox(
              height: height - MediaQuery.of(context).padding.top,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.fill,
                    height: height * 0.2,
                  ),
                  SizedBox(height: height * 0.027241),
                  DefaultTextFormField(
                    hintText: 'Email',
                    controller: emailController,
                    prefixIconImageName: 'Email',
                    validator: (value) {
                      if (value == null || value.length < 5) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.01816),
                  DefaultTextFormField(
                    hintText: 'Password',
                    isPassword: true,
                    controller: passwordController,
                    prefixIconImageName: 'lock',
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.027241),
                  DefaultElevatedButton(
                    label: 'Login',
                    onPressed: login,
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                  SizedBox(height: height * 0.0227),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don’t Have Account ?', style: text.titleMedium),
                      TextButton(
                        onPressed:
                            () => Navigator.of(
                              context,
                            ).pushReplacementNamed(AppRoutes.registerScreen),
                        child: Text('Create Account'),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.0227),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: AppColors.primary,
                          endIndent: 20,
                          indent: 20,
                        ),
                      ),
                      Text(
                        'Or',
                        style: text.titleMedium!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: AppColors.primary,
                          endIndent: 20,
                          indent: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.0227),
                  DefaultElevatedButton(
                    label: 'Login With Google',
                    backgroundColor: AppColors.backgroundDark,
                    prefixSvgPath: 'assets/icons/google.svg',
                    onPressed: () async {
                      logWithGoogle(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login() {
    if (formKey.currentState!.validate()) {
      FireBaseService.login(
            email: emailController.text,
            password: passwordController.text,
          )
          .then((user) {
            Provider.of<UserProvider>(
              context,
              listen: false,
            ).updateCurrentUser(user);
            Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);
            // لعرض رسالة نجاح بعد تسجيل الدخول
            // ignore: use_build_context_synchronously
            UIUtils.showSuccessMessage(context, 'Login successful!');
          })
          .catchError((error) {
            String? errorMessage;
            if (error is FirebaseAuthException) {
              errorMessage = error.message;
            }
            // تمرير الـ context إلى دالة رسالة الخطأ
            // ignore: use_build_context_synchronously
            UIUtils.showErrorMessage(context, errorMessage);
          });
    }
  }

  Future<UserCredential?> logWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        showCustomMessage(
          context: context,
          title: 'Login Failed',
          message: 'Google sign-in was cancelled. Please try again.',
          actionText: 'OK',
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.orange,
        );
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? '',
        email: userCredential.user!.email ?? '',
        favouriteEventsIds: [],
      );
      // حفظ المستخدم في الفايرستور لو جديد
      await FireBaseService.createUser(userModel);

      // تحديث المستخدم الحالي في البروفايدر
      Provider.of<UserProvider>(
        context,
        listen: false,
      ).updateCurrentUser(userModel);

      //  تحديث الـ UserProvider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateCurrentUser(userModel);

      //  تحميل كل الأحداث من Firestore
      final eventsProvider = Provider.of<EventsProvider>(
        context,
        listen: false,
      );
      await eventsProvider.getEvents();

      //  فلترة الأحداث المفضلة
      eventsProvider.filterFavouriteEvents(userModel.favouriteEventsIds);

      //  الانتقال إلى الشاشة الرئيسية
      Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);
      showCustomMessage(
        context: context,
        title: 'Success',
        message: 'You have successfully signed in with Google!',
        actionText: 'OK',
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      );

      return userCredential;
    } catch (e) {
      print('Google Sign-In Error: $e');
      showCustomMessage(
        context: context,
        title: 'Error',
        message: 'An error occurred during sign-in: $e',
        actionText: 'OK',
        icon: Icons.error_outline,
        iconColor: Colors.red,
      );
      return null;
    }
  }
}

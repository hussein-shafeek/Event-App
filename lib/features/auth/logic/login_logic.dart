import 'package:evently/core/models/user_model.dart';
import 'package:evently/core/providers/events_provider.dart';
import 'package:evently/core/providers/user_provider.dart';
import 'package:evently/core/routes/routes.dart';
import 'package:evently/core/services/firebase.dart';
import 'package:evently/features/auth/data/ui_utils.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginLogic {
  static Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final t = AppLocalizations.of(context)!;

    try {
      final user = await FireBaseService.login(
        email: email,
        password: password,
      );

      Provider.of<UserProvider>(context, listen: false).updateCurrentUser(user);

      Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);

      UIUtils.showSuccessMessage(context, t.loginSuccess);
    } catch (error) {
      String? errorMessage;
      if (error is FirebaseAuthException) {
        errorMessage = error.message;
      }
      UIUtils.showErrorMessage(context, errorMessage ?? t.somethingWrong);
    }
  }

  static Future<UserCredential?> loginWithGoogle(BuildContext context) async {
    final t = AppLocalizations.of(context)!;

    try {
      final googleSignIn = GoogleSignIn(scopes: ['email']);
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        UIUtils.showErrorMessage(context, t.googleSignInCancelled);
        return null;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      final userModel = UserModel(
        id: userCredential.user!.uid,
        name: userCredential.user!.displayName ?? '',
        email: userCredential.user!.email ?? '',
        favouriteEventsIds: [],
      );

      await FireBaseService.createUser(userModel);

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateCurrentUser(userModel);

      final eventsProvider = Provider.of<EventsProvider>(
        context,
        listen: false,
      );
      await eventsProvider.getEvents();
      eventsProvider.filterFavouriteEvents(userModel.favouriteEventsIds);

      Navigator.of(context).pushReplacementNamed(AppRoutes.homeScreen);

      UIUtils.showSuccessMessage(context, t.googleSignInSuccess);

      return userCredential;
    } catch (e) {
      UIUtils.showErrorMessage(context, '${t.googleSignInFailed} $e');
      return null;
    }
  }
}

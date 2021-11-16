import 'package:biblio_files/Styles/constants.dart';
import 'package:biblio_files/screens/home_page.dart';
import 'package:biblio_files/screens/register_page.dart';
import 'package:biblio_files/widgets/custom_button.dart';
import 'package:biblio_files/widgets/custom_image_button.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:twitter_login/twitter_login.dart';
import 'dart:io' show Platform;

void AccountLinker(_email, pendingCredential) async {
  String? email = _email;

  List<String> userSignInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email!);

  if (userSignInMethods.first == 'facebook.com') {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential credential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    await userCredential.user!.linkWithCredential(pendingCredential!);
  }

  if (userSignInMethods.first == 'google.com') {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    await userCredential.user!.linkWithCredential(pendingCredential!);
  }

  if (userSignInMethods.first == 'twitter.com') {
    final twitterLogin = TwitterLogin(
        apiKey: 'spNv8GQWq0Wofh8PaFGypRLKU',
        apiSecretKey: 'AdHnWhI91R9FefYzmykjS89DgJZWxc89Z5sJhc9sBM7VI1OJZK',
        redirectURI: 'biblio://');

    await twitterLogin.login().then((value) async {
      final credential = TwitterAuthProvider.credential(
          accessToken: value.authToken!,
          secret: value.authTokenSecret!);

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      await userCredential.user!.linkWithCredential(pendingCredential!);
    });
  }
}






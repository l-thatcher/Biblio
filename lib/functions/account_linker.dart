import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:twitter_login/twitter_login.dart';

//this function is used to link two accounts such as google and facebook accounts that share the same email

void accountLinker(_email, pendingCredential) async {
  String? email = _email;

  //use a firebase function to check the sign in methods associated with that email
  List<String> userSignInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email!);


  //use if statements to link the sign in email with the existing account
  if (userSignInMethods.first == 'facebook.com') {
    //if statements to check if the user is on pc or mobile
    if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential credential = FacebookAuthProvider.credential(
          loginResult.accessToken!.token);

      //sign the user in with their credentials
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      //link the two accounts together
      await userCredential.user!.linkWithCredential(pendingCredential!);
    } else {
      //the same but adapted for pc capabilities
      FacebookAuthProvider facebookProvider = FacebookAuthProvider();
      UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(facebookProvider);
      await userCredential.user!.linkWithCredential(pendingCredential!);
    }
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
    if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
      final twitterLogin = TwitterLogin(
          apiKey: 'spNv8GQWq0Wofh8PaFGypRLKU',
          apiSecretKey: 'AdHnWhI91R9FefYzmykjS89DgJZWxc89Z5sJhc9sBM7VI1OJZK',
          redirectURI: 'biblio://');

      await twitterLogin.login().then((value) async {
        final credential = TwitterAuthProvider.credential(
            accessToken: value.authToken!,
            secret: value.authTokenSecret!);

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);
        await userCredential.user!.linkWithCredential(pendingCredential!);
      });
    } else {
      TwitterAuthProvider twitterProvider = TwitterAuthProvider();
      UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(twitterProvider);
      await userCredential.user!.linkWithCredential(pendingCredential!);
    }
  }
}






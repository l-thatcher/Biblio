import 'package:biblio_files/functions/account_linker.dart';
import 'package:biblio_files/widgets/custom_image_button.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:flutter/foundation.dart';
import 'package:biblio_files/services/database.dart';

//this is shown on the user sign in and register screen, and allows the users to use google, facebook, or twitter to sign in, apple will also need to be added to be released on iphone,
//but this requires payment to be implemented

class ThirdPartySignIn extends StatefulWidget {
  const ThirdPartySignIn({Key? key}) : super(key: key);

  @override
  _ThirdPartySignInState createState() => _ThirdPartySignInState();
}

class _ThirdPartySignInState extends State<ThirdPartySignIn> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  final String method = "";


  //this popup is used when a user tries to sign into an account with a third party service but they already have an account to link them
  Future<void> _showPasswordReq() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Already Exists'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.preExistingUserError),
                CustomInput(
                    text : AppLocalizations.of(context)!.passwordHint,
                    primaryInput: true,
                    hiddenText: true,
                    onChanged: (value) {
                      password = value;
                    }),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //this popup is used when a user tries to sign into an account with a third party service but they already have an account from another provider, then lto link them
  Future<void> _linkAccountDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User linked to another account'),
          content: SingleChildScrollView(
              child: Text(AppLocalizations.of(context)!.accountLinkDialog)
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<String?> signInMaster(credential) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.additionalUserInfo!.isNewUser == true) {
        createDetails();
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    }  on FirebaseAuthException catch (e) {
      //Account liniking adapted from FluterFire error handing docs - https://firebase.flutter.dev/docs/auth/error-handling/
      if (e.code == 'account-exists-with-different-credential') {
        String? email = e.email;
        AuthCredential? pendingCredential = e.credential;

        List<String> userSignInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email!);

        if (userSignInMethods.first == 'password') {
          // Prompt the user to enter their password
          await _showPasswordReq();
          password == password;

          try {
            // Sign the user in to their account with the password
            UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email,
              password: password,
            );

            // Link the pending credential with the existing account
            await userCredential.user!.linkWithCredential(pendingCredential!);
          } catch (e) {
            print(e.toString());
            signInMaster(credential);
          }
        } else {
          await _linkAccountDialog();
          accountLinker(e.email, e.credential);
        }
      }
    } catch (e) {
      return e.toString();
    }
  }

  //upload the information on the new user to the database
  Future<String?> createDetails() async {
    String? email = FirebaseAuth.instance.currentUser!.email;
    String? name = FirebaseAuth.instance.currentUser!.displayName;
    String _email = email!;
    String _name = name ?? email.split("@")[0];
    var currentUser = FirebaseAuth.instance.currentUser;

    Map<String, dynamic> userInfoMap = {
      "email": _email,
      "name": _name,
      "course" : "Other",
      "savedPosts" : [],
      "uuid" : currentUser!.uid
    };

    databaseMethods.uploadUserInfo(userInfoMap, currentUser.uid);
  }

  Future<String?> signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      signInMaster(credential);
    } on PlatformException catch (e) {if (e.code == 'popup_closed_by_user') {
      return AppLocalizations.of(context)!.googleClosedError;
    }
    return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  submitGoogle() async {
    setState(() {
      googleLoading = true;
    });
    String? signInString = await signInWithGoogle();
    if(signInString != null){
      setState(() {
        googleLoading = false;
      });
      errorMsg = signInString;
    }
  }


  Future<String?> signInWithFacebook() async {
    //platform checker from https://stackoverflow.com/questions/58459483/unsupported-operation-platform-operatingsystem by user Quentin CG accessed 15/11/21
    if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
      try{
        // Trigger the sign-in flow
        final LoginResult loginResult = await FacebookAuth.instance.login();

        // Create a credential from the access token
        final OAuthCredential credential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

        // Once signed in, return the UserCredential
        signInMaster(credential);
      } catch (e) {
        return e.toString();
      }
    } else {
      try {
        // Trigger the authentication flow
        FacebookAuthProvider facebookProvider = FacebookAuthProvider();

        facebookProvider.addScope('email');
        facebookProvider.setCustomParameters({
          'display': 'popup',
        });

        UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(facebookProvider);
        if (userCredential.additionalUserInfo!.isNewUser == true){
          createDetails();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          await _linkAccountDialog();
          accountLinker(e.email, e.credential);
        }
        return e.message;
      } catch (e){
        return e.toString();
      }
    }
  }

  submitFacebook() async {
    setState(() {
      facebookLoading = true;
    });
    String? signInString = await signInWithFacebook();
    if(signInString != null){
      setState(() {
        facebookLoading = false;
      });
      errorMsg = signInString;
    }
  }

  Future<String?> signInWithTwitter() async {
    if ((defaultTargetPlatform == TargetPlatform.iOS) || (defaultTargetPlatform == TargetPlatform.android)) {
        try {
          final twitterLogin = TwitterLogin(
              apiKey: 'spNv8GQWq0Wofh8PaFGypRLKU',
              apiSecretKey: 'AdHnWhI91R9FefYzmykjS89DgJZWxc89Z5sJhc9sBM7VI1OJZK',
              redirectURI: 'biblio://');

          await twitterLogin.login().then((value) async {

          final credential = TwitterAuthProvider.credential(
                accessToken: value.authToken!,
                secret: value.authTokenSecret!);

          signInMaster(credential);
          });
        } catch (e) {
          return e.toString();
        }
    } else {
      try{
        TwitterAuthProvider twitterProvider = TwitterAuthProvider();
        UserCredential userCredential = await FirebaseAuth.instance.signInWithPopup(twitterProvider);
        if (userCredential.additionalUserInfo!.isNewUser == true){
          createDetails();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          await _linkAccountDialog();
          accountLinker(e.email, e.credential);
        }
        return e.message;
      } catch (e) {
        return e.toString();
      }
    }
  }

  submitTwitter() async {
    setState(() {
      twitterLoading = true;
    });
    String? signInString = await signInWithTwitter();
    if(signInString != null){
      setState(() {
        twitterLoading = false;
      });
      errorMsg = signInString;
    }
  }

  bool formLoading = false;
  bool googleLoading = false;
  bool facebookLoading = false;
  bool twitterLoading = false;

  String email = "";
  String password = "";
  String errorMsg = "";


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomImageButton(
          onPressed: () {
            submitGoogle();
          },
          image : 'lib/assets/googleLogo.png',
          outlined: true,
          isLoading: googleLoading,
        ),
        CustomImageButton(
          onPressed: () {
            submitFacebook();
          },
          image : 'lib/assets/facebookLogo.png',
          outlined: true,
          isLoading: facebookLoading,
        ),
        CustomImageButton(
          onPressed: () {
            submitTwitter();
          },
          image : 'lib/assets/twitterLogo.png',
          outlined: true,
          isLoading: twitterLoading,
        ),
        // CustomImageButton(
        //   onPressed: () {
        //
        //   },
        //   image : 'lib/assets/appleLogo.png',
        //   outlined: true,
        // ),
      ],
    );
  }
}

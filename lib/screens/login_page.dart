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


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


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

  Future<String?> signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return('Wrong password provided for that user.');
      } else if (e.code == 'unknown') {
        return ('Fields have been left empty');
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void submitForm() async {
    setState(() {
      formLoading = true;
    });
    String? signInString = await signIn();
    if(signInString != null){
      setState(() {
        formLoading = false;
      });
      errorMsg = signInString;
    }
  }

  Future<String?> signInMaster(credential) async{
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
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
        }

        if (userSignInMethods.first == 'facebook.com') {
          final LoginResult loginResult = await FacebookAuth.instance.login();

          // Create a credential from the access token
          final OAuthCredential credential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

          await _linkAccountDialog();
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
          await _linkAccountDialog();
          UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
          await userCredential.user!.linkWithCredential(pendingCredential!);
        }

        if (userSignInMethods.first == 'twitter.com') {
          await _linkAccountDialog();
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
    } catch (e) {
      return e.toString();
    }
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
    if (Platform.isAndroid || Platform.isIOS) {
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
      // Trigger the authentication flow
      FacebookAuthProvider facebookProvider = FacebookAuthProvider();

      facebookProvider.addScope('email');
      facebookProvider.setCustomParameters({
        'display': 'popup',
      });

      // Once signed in, return the UserCredential
      FirebaseAuth.instance.signInWithPopup(facebookProvider);
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
    if (Platform.isAndroid || Platform.isIOS) {
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

    } else {
      TwitterAuthProvider twitterProvider = TwitterAuthProvider();
      FirebaseAuth.instance.signInWithPopup(twitterProvider);
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

  late FocusNode passwordFocusNode;

  @override
  void initState() {
    passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.welcome,style: constants.headingText,),
                  Column(
                    children: [
                      Text(errorMsg, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16)),
                      CustomInput(
                        text : AppLocalizations.of(context)!.emailHint,
                        primaryInput: true,
                        onChanged: (value) {
                          email = value;
                        },
                        onSubmitted: (value) {
                          passwordFocusNode.requestFocus();
                        },
                        textInputAction: TextInputAction.next,),

                      CustomInput(
                        text : AppLocalizations.of(context)!.passwordHint,
                        primaryInput: true,
                        focusNode: passwordFocusNode,
                        hiddenText: true,
                        onChanged: (value) {
                          password = value;
                        },
                      ),

                      CustomButton(
                        text: AppLocalizations.of(context)!.signInTxt,
                        onPressed: () {
                          submitForm();
                        },
                        isLoading: formLoading,
                      ),

                      Text(AppLocalizations.of(context)!.alternateSignIn,style: constants.fadedText,),

                      Row(
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
                            CustomImageButton(
                              onPressed: () {

                              },
                              image : 'lib/assets/appleLogo.png',
                              outlined: true,
                            ),
                          ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(AppLocalizations.of(context)!.newAccountPrompt,style: constants.fadedText,),
                      CustomButton(
                        text: AppLocalizations.of(context)!.createAccountTxt,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                              ),
                          );
                        },
                        outlined: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}

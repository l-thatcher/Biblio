import 'package:biblio_files/Styles/constants.dart';
import 'package:biblio_files/functions/account_linker.dart';
import 'package:biblio_files/screens/home_page.dart';
import 'package:biblio_files/screens/register_page.dart';
import 'package:biblio_files/widgets/custom_button.dart';
import 'package:biblio_files/widgets/custom_image_button.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:biblio_files/widgets/third_party_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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
    List<String> userSignInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return('No user found for that email.');
      } else if (e.code == 'unknown') {
        return ('Fields have been left empty');
      } else if (!userSignInMethods.contains('password')) {
        return('This email is associated with an alternate sign in method');
      } else if (e.code == 'wrong-password') {
        return('Wrong password provided for that user.');
      }
    }
    catch (e) {
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
      return KeyboardDismissOnTap(
        child: Scaffold(
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
                        Text(errorMsg, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16), textAlign: TextAlign.center,),
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

                        ThirdPartySignIn(),
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
        ),
      );
  }
}

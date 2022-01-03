import 'dart:async';
import 'package:biblio_files/Styles/constants.dart';
import 'package:biblio_files/services/database.dart';
import 'package:biblio_files/widgets/custom_button.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:biblio_files/widgets/third_party_sign_in.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {

  DatabaseMethods databaseMethods = new DatabaseMethods();

  Future<String?> _createAccount() async {
    if (newEmail.toLowerCase() == confEmail.toLowerCase()) {
      if (newPassword == confPassword) {
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
              email: newEmail,
              password: newPassword
          );
          var currentUser = FirebaseAuth.instance.currentUser;
          Map<String, dynamic> userInfoMap = {
            "email" : newEmail,
            "name" : newName,
            "savedPosts" : {"postID" : ""},
            "uuid" : currentUser!.uid
          };

          databaseMethods.uploadUserInfo(userInfoMap, currentUser.uid);

          return null;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            return ('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            return ('The account already exists for that email.');
          } else if (e.code == 'unknown') {
            return ('Fields have been left empty');
          }
          return e.message;
        } catch (e) {
          return (e.toString());
        }
      } else {
        return ('Passwords do not match');
      }
    } else {
      return ('Emails do not match');
    }
  }

  void submitForm() async {
    setState(() {
      formLoading = true;
    });
    String? createAccountString = await _createAccount();
    if(createAccountString != null){
      setState(() {
        formLoading = false;
      });
      errorMsg = createAccountString;
    } else {
      Navigator.pop(context);
    }
  }
  bool formLoading = false;
  String errorMsg = "";

  String newName = "";
  String newEmail = "";
  String newPassword = "";
  String confEmail = "";
  String confPassword = "";

  bool googleLoading = false;
  bool facebookLoading = false;
  bool twitterLoading = false;
  bool btnVisible = true;

  String name = "";
  String email = "";
  String password = "";

  late FocusNode EmailFocusNode;
  late FocusNode confEmailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode confpasswordFocusNode;
  late StreamSubscription<bool> keyboardSubscription;


  @override
  void initState() {
    EmailFocusNode = FocusNode();
    confEmailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    confpasswordFocusNode = FocusNode();
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();

    // keyboard visibility checker from https://pub.dev/packages/flutter_keyboard_visibility accessed 15/11/21
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        btnVisible = !visible;
      });
    });

  }

  @override
  void dispose() {
    EmailFocusNode.dispose();
    confEmailFocusNode.dispose();
    passwordFocusNode.dispose();
    confpasswordFocusNode.dispose();
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      return KeyboardDismissOnTap(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.registerHeading, style: constants.headingText,),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(errorMsg, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16)),
                        CustomInput(
                          text : AppLocalizations.of(context)!.nameHint, primaryInput: false,
                          onChanged: (value) {
                            newName = value;
                          },
                          onSubmitted: (value) {
                            EmailFocusNode.requestFocus();
                          },
                          textInputAction: TextInputAction.next,),
                        CustomInput(
                          text : AppLocalizations.of(context)!.emailHint, primaryInput: false,
                          onChanged: (value) {
                            newEmail = value;
                          },
                          onSubmitted: (value) {
                            confEmailFocusNode.requestFocus();
                          },
                          focusNode: EmailFocusNode,
                          textInputAction: TextInputAction.next,),

                        CustomInput(
                          text : AppLocalizations.of(context)!.emailConfHint, primaryInput: false,
                          onChanged: (value) {
                            confEmail = value;
                          },
                          onSubmitted: (value) {
                            passwordFocusNode.requestFocus();
                          },
                          focusNode: confEmailFocusNode,
                          textInputAction: TextInputAction.next,),

                        CustomInput(
                          text : AppLocalizations.of(context)!.passwordHint, primaryInput: false,
                          hiddenText: true,
                          onChanged: (value) {
                            newPassword = value;
                          },
                          onSubmitted: (value) {
                            confpasswordFocusNode.requestFocus();
                          },
                          focusNode: passwordFocusNode,
                          textInputAction: TextInputAction.next,),

                        CustomInput(
                          text : AppLocalizations.of(context)!.passwordConfHint, primaryInput: false,
                          hiddenText: true,
                          onChanged: (value) {
                            confPassword = value;
                          },
                          onSubmitted: (vale) {
                            submitForm();
                          },
                          focusNode: confpasswordFocusNode,),

                        CustomButton(
                          text: AppLocalizations.of(context)!.signUpTxt,
                          onPressed: () {
                            submitForm();
                          },
                          isLoading: formLoading,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.alternateSignUp,style: constants.fadedText,),
                        ThirdPartySignIn(),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.existingAccountPrompt,style: constants.fadedText,),
                        CustomButton(
                          text: AppLocalizations.of(context)!.existingUserTxt,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          outlined: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}

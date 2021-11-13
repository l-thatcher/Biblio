import 'package:biblio_files/Styles/constants.dart';
import 'package:biblio_files/screens/home_page.dart';
import 'package:biblio_files/screens/register_page.dart';
import 'package:biblio_files/widgets/custom_button.dart';
import 'package:biblio_files/widgets/custom_image_button.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  Future<String?> _signIn() async {
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
    String? signInString = await _signIn();
    if(signInString != null){
      setState(() {
        formLoading = false;
      });
      errorMsg = signInString;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    setState(() {
      googleLoading = true;
    });
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  bool formLoading = false;
  bool googleLoading = false;

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
                                signInWithGoogle();
                              },
                              image : 'lib/assets/googleLogo.png',
                              outlined: true,
                              isLoading: googleLoading,
                            ),
                            CustomImageButton(
                              onPressed: () {

                              },
                              image : 'lib/assets/facebookLogo.png',
                              outlined: true,
                            ),
                            CustomImageButton(
                              onPressed: () {

                              },
                              image : 'lib/assets/twitterLogo.png',
                              outlined: true,
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

import 'package:biblio_files/Styles/constants.dart';
import 'package:biblio_files/screens/home_screen.dart';
import 'package:biblio_files/screens/register_page.dart';
import 'package:biblio_files/widgets/custom_button.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:biblio_files/widgets/third_party_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

//the log in page for the app

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //the sign in function
  Future<String?> signIn() async {
    //take in variables and create an account with firestore
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return null;
    } on FirebaseAuthException catch (e) {
      //return cutom error messages for common issues
      if (e.code == 'user-not-found') {
        return('No user found for that email.');
      } else if (e.code == 'unknown') {
        return ('Fields have been left empty');
      } else if (e.code == 'wrong-password') {
        List<String> userSignInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        if (!userSignInMethods.contains('password')) {
          return('This email is associated with an alternate sign in method');
        } else {
          return('Wrong password provided for that user.');
        }
      }
      return e.message;
    } catch (e) {
      //if it is not one of those errors the user will be given the full error message
      return e.toString();
    }
  }

  //a function to handle signing up and display the loading buttom
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
    } else {
      Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
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
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Center(
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.15),
                            child: Text(AppLocalizations.of(context)!.welcome,style: Constants.headingText,)
                        ),
                        Text(errorMsg, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16), textAlign: TextAlign.center,),
                        CustomInput(
                          //use custom designed input widgets
                          text : AppLocalizations.of(context)!.emailHint,
                          primaryInput: true,
                          //set the email var to the string in the input
                          onChanged: (value) {
                            email = value;
                          },
                          onSubmitted: (value) {
                            //lead to the next input field rather than closing the keyboard on next
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

                        Text(AppLocalizations.of(context)!.alternateSignIn,style: Constants.fadedText,),
                        const ThirdPartySignIn(),
                      ],
                    ),
                    Column(
                      children: [
                        Text(AppLocalizations.of(context)!.logInPrompt,style: Constants.fadedText,),
                        CustomButton(
                          text: AppLocalizations.of(context)!.createAccountTxt,
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
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

import 'dart:async';
import 'package:biblio_files/Styles/constants.dart';
import 'package:biblio_files/services/database.dart';
import 'package:biblio_files/widgets/course_selector.dart';
import 'package:biblio_files/widgets/custom_button.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:biblio_files/widgets/third_party_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class EditDetails extends StatefulWidget {
  const EditDetails({Key? key}) : super(key: key);

  @override
  _EditDetails createState() => _EditDetails();
}

class _EditDetails extends State<EditDetails> {

  //this page is used to change the users email. it uses a collection reference to get the user
  CollectionReference _users = FirebaseFirestore.instance.collection('users');

  Future<String?> _changeEmail() async {
    //a funtion to change the email in the users account
    var currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    _users
        .doc(currentUserUid)
        .update({'course': newCourse})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  void submitForm() async {
    setState(() {
      formLoading = true;
    });
    String? createAccountString = await _changeEmail();
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

  String newCourse = "";


  bool btnVisible = true;

  late StreamSubscription<bool> keyboardSubscription;


  @override
  void initState() {
    var keyboardVisibilityController = KeyboardVisibilityController();

    // keyboard visibility checker from https://pub.dev/packages/flutter_keyboard_visibility accessed 15/11/21
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        btnVisible = !visible;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
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
                constraints: BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text("Change details", style: constants.headingText,),
                        Text(errorMsg, style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16)),
                      ],
                    ),

                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            color: Colors.transparent,
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 5,
                          ),
                          child: CourseSelector(onChanged: (value) {
                            newCourse = value;
                          },),
                        ),
                      ],
                    ),

                    CustomButton(
                      text: "Save",
                      onPressed: () {
                        submitForm();
                      },
                      isLoading: formLoading,
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

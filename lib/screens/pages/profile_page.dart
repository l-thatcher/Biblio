import 'package:biblio_files/screens/edit_details.dart';
import 'package:biblio_files/widgets/condition_selector.dart';
import 'package:biblio_files/widgets/custom_button.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:biblio_files/widgets/course_selector.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:biblio_files/Styles/constants.dart';



class Profilepage extends StatefulWidget {
  const Profilepage({Key? key}) : super(key: key);

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  Widget build(BuildContext context) {
    final DocumentReference _userRef =  FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid);

    String newCourse = "";
    final courseOptions = ['Other', 'Physics', 'Chemestry', 'Computer Science', 'Maths', 'Engineering'];


    return Container(
      child: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future: _userRef.get(),
          builder: (context, snapshot) {
            if(snapshot.hasError){
              return Scaffold(
                body: Center(
                  child: Text("Error: ${snapshot.error}"),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {

              Map<String, dynamic> documentData = snapshot.data!.data() as Map<String, dynamic>;

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${documentData["name"]}", style: constants.titleText),
                  Text("Email - ${documentData["email"]}", style: constants.headingText),
                  Text("Course - ${documentData["course"]}", style: constants.headingText),

                  Column(
                    children: [
                      CustomButton(
                        text: "Change Course",
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => EditDetails(),
                            ),
                          );
                        },
                        outlined: true,
                      ),
                      CustomButton(
                        text: "Sign out",
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        outlined: false,
                      ),
                    ],
                  ),
                ],
              );
            }
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),

      ),
    );
  }
}

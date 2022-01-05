import 'package:biblio_files/widgets/custom_button.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:biblio_files/widgets/course_selector.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:biblio_files/Styles/constants.dart';



class Profilepage extends StatelessWidget {
  const Profilepage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final DocumentReference _userRef =  FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid);

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

              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("${documentData["name"]}", style: constants.titleText),
                    Text("Email - ${documentData["email"]}", style: constants.headingText),
                    Text("Course - ${documentData["course"]}", style: constants.headingText),

                    CustomButton(
                      text: "Sign out",
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                      },
                      outlined: true,
                    ),
                  ],
                ),
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

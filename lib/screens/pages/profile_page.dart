import 'package:biblio_files/screens/edit_details.dart';
import 'package:biblio_files/widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';

import '../login_page.dart';



class Profilepage extends StatefulWidget {
  const Profilepage({Key? key}) : super(key: key);

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  @override
  Widget build(BuildContext context) {
    final DocumentReference _userRef =  FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid);

    //profile page for the user, it allows them to check their details and change the course they are on. In future development this page could incorporate profile pictures

    return SafeArea(
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
                Text("${documentData["name"]}", style: Constants.titleText),
                Text("Email - ${documentData["email"]}", style: Constants.headingText),
                Text("Course - ${documentData["course"]}", style: Constants.headingText),

                Column(
                  children: [
                    CustomButton(
                      text: "Change Course",
                      onPressed: () {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => const EditDetails(),
                          ),
                        );
                      },
                      outlined: true,
                    ),
                    CustomButton(
                      text: "Sign out",
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      outlined: false,
                    ),
                  ],
                ),
              ],
            );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),

    );
  }
}

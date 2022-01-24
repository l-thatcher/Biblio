import 'package:biblio_files/widgets/course_rows.dart';
import 'package:biblio_files/widgets/post_rows.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  //this is the main home page of the app where the user will normally land

  final Stream<DocumentSnapshot> _userRef =  FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      //use a stream builder to get details on the current user from the db
      child: StreamBuilder<DocumentSnapshot>(
        stream: _userRef,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> streamSnapshot) {

          if(streamSnapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text("Error: ${streamSnapshot.error}"),
              ),
            );
          }

          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          //create a list of the users saved posts from the stream snapshot
          List<String>? savedPosts = List.from(streamSnapshot.data!.get('savedPosts'));


          return SafeArea(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 15,
                    left: 24,
                    right: 24,
                    bottom: 24,
                  ),
                  child: Text(AppLocalizations.of(context)!.homeTitle, style: Constants.titleText,),
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 80,
                    left: 28,
                    right: 20,
                    bottom: 20,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //populate the page with rows bassed of the users course, saved and new listings to the app
                      CourseRows(title: "Books from your course", userCourse: streamSnapshot.data!.get('course'),),
                      savedPosts.isEmpty ? CourseRows(title: "Saved posts", userCourse: "") : PostRows(title: "Saved posts", postList: savedPosts),
                      PostRows(title: "New listings",),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

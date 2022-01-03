import 'package:biblio_files/widgets/post_rows.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:biblio_files/Styles/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  List<String> savedPosts = [];

  final CollectionReference _userRef =  FirebaseFirestore.instance.collection("users");

  getSaved() {
    FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
      savedPosts = List.from(value.data()!['savedPosts']);
    });
  }

  @override
  void initState() {
    getSaved();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<DocumentSnapshot>(
        future: _userRef.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            savedPosts = List.from(snapshot.data!.get('savedPosts'));
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
                    child: Text(AppLocalizations.of(context)!.homeTitle, style: constants.titleText,),
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
                        PostRows(title: "Recently Viewed",),
                        PostRows(title: "Saved posts", postList: savedPosts),
                        PostRows(title: "Your course nearby",),
                      ],
                    ),
                  )
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
    );
  }
}

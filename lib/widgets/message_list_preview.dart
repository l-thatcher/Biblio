import 'package:biblio_files/screens/edit_post_page.dart';
import 'package:biblio_files/screens/personal_post_page.dart';
import 'package:biblio_files/screens/post_page.dart';
import 'package:biblio_files/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';



class MessageListPreview extends StatefulWidget {
  String? image;
  String? chatName;
  String? user1;
  String? user2;


  MessageListPreview({Key? key, this.image, this.chatName, this.user1, this.user2}) : super(key: key);

  @override
  State<MessageListPreview> createState() => _MessageListPreviewState();
}

class _MessageListPreviewState extends State<MessageListPreview> {
  String currentUserID = FirebaseAuth.instance.currentUser!.uid;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  CollectionReference _userRef = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _userRef.doc((currentUserID==widget.user1) ? widget.user2 : widget.user1).get(),
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

          return Container(
            padding: EdgeInsets.only(
              top: 5,
              bottom: 5,
            ),
            margin: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.1,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                    spreadRadius: 0.05,
                    blurRadius: 20,
                  )
                ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    child: Image.network(widget.image!)
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(documentData['name'], style: constants.subtitleText,),
                      Text(widget.chatName!),
                    ],
                  ),
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
    );
  }
}

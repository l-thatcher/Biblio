import 'package:biblio_files/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';


//each of the users chats are shown here, it was adapted from the post list preview and works in a similar way
class MessageListPreview extends StatefulWidget {
  final String? image;
  final String? chatName;
  final String? user1;
  final String? user2;


  const MessageListPreview({Key? key, this.image, this.chatName, this.user1, this.user2}) : super(key: key);

  @override
  State<MessageListPreview> createState() => _MessageListPreviewState();
}

class _MessageListPreviewState extends State<MessageListPreview> {
  String currentUserID = FirebaseAuth.instance.currentUser!.uid;

  DatabaseMethods databaseMethods = DatabaseMethods();
  final CollectionReference _userRef = FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      //check if the current user is user one or two then get the correct stream accordingly
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
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 5,
            ),
            margin: const EdgeInsets.all(10),
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
                Image.network(widget.image!),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(documentData['name'], style: Constants.subtitleText,),
                      Text(widget.chatName!),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

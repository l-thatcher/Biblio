import 'package:biblio_files/services/database.dart';
import 'package:biblio_files/widgets/message_list_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_page.dart';

class ContactsPage extends StatefulWidget {

  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  var currentUser = FirebaseAuth.instance.currentUser;

  //widget to show the user a list of open chats
  Widget chatRoomList(){
    //stream of the users chats from database
    final Stream<QuerySnapshot> chatRoomStream = FirebaseFirestore.instance.collection("chatroom").where("users", arrayContains: currentUser!.uid).snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: chatRoomStream,
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          //return a list view of MessageListPreview widgets
          return ListView(
            children: snapshot.data!.docs.map((document) {
              return GestureDetector(
                //link to the chat tapped on
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => ChatPage(document["chatroomID"], document["chatName"], document["image"])
                  ));
                },
                  child: MessageListPreview(image: document["image"], chatName: document["chatName"], user1: document["users"][0],  user2: document["users"][1]));
            }).toList(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: chatRoomList()
    );
  }
}

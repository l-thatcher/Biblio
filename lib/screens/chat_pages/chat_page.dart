import 'package:biblio_files/services/database.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:biblio_files/widgets/message_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




//chat functionality adapted from https://www.youtube.com/watch?v=X00Xv7blBo0 by Sanskar Tiwari - first accessed 17/11/21
class ChatPage extends StatefulWidget {
  String chatroomID;
  String bookName;
  String image;

  ChatPage(this.chatroomID, this.bookName, this.image, {Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  var currentUser = FirebaseAuth.instance.currentUser;


  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
        "message" : messageController.text,
        "sentBy" : currentUser!.uid,
        "time" : DateTime.now().microsecondsSinceEpoch
      };
      databaseMethods.addMessages(widget.chatroomID, messageMap);
      messageController.text = "";
    }
  }

  Widget chatMessageList(){
    final Stream<QuerySnapshot> chatMessageStream = FirebaseFirestore.instance.collection("chatroom").doc(widget.chatroomID)
        .collection("chats").orderBy("time", descending: false).snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: chatMessageStream,
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return MessageTile(message: document["message"], fromMe: document["sentBy"] == currentUser!.uid,);
            }).toList(),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardDismissOnTap(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 30,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("lib/assets/backArrow.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              Text(widget.bookName, style: constants.titleText,),
                              Container(
                                width: 40,
                                height: 40,
                                child: Image.network(widget.image),
                              ),
                            ],
                          ),
                          Expanded(child: chatMessageList()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 5,
                color: Theme.of(context).colorScheme.secondary,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 30,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        right: 25,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              spreadRadius: 0.05,
                              blurRadius: 20,
                            )
                          ]
                      ),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: MediaQuery.of(context).size.height * 0.09,
                                    maxHeight: MediaQuery.of(context).size.height * 0.15,
                                  ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(0),
                                  color: Colors.transparent,
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 5,
                                ),
                                  child:TextField(
                                    onSubmitted: sendMessage(),
                                    controller: messageController,
                                  ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                sendMessage();
                              },
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("lib/assets/frontArrow.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

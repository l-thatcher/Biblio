import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods{

  uploadUserInfo(userMap, uuid){
    FirebaseFirestore.instance.collection('users').doc(uuid).set(userMap);
  }

  newUserPost(postMap){
    FirebaseFirestore.instance.collection('posts').add(postMap);
  }

  getUserByUid(String uid) async {
    return await FirebaseFirestore.instance.collection("users").where("uuid", isEqualTo: uid).get();
  }
  
  createChatRoom(String chatRoomID, chatRoomMap){
    FirebaseFirestore.instance.collection("chatroom").doc(chatRoomID).set(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  addMessages(String chatroomID, messageMap) {
    FirebaseFirestore.instance.collection("chatroom").doc(chatroomID)
        .collection("chats").add(messageMap)
        .catchError((e) {
          print(e.toString());
    });
  }

  getMessages(String chatroomID) async {
    return await FirebaseFirestore.instance.collection("chatroom").doc(chatroomID)
        .collection("chats").snapshots();
  }

  getChatRooms(userID){
    return FirebaseFirestore.instance.collection("chatroom").where("users", arrayContains: userID).snapshots();
  }
}
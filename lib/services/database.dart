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

  deleteChatsWithUid(String postID) async {
    //delete functrion adapted from https://stackoverflow.com/questions/53089517/how-to-delete-all-documents-in-collection-in-firestore-with-flutter by user copsOnRoad accessed 17/01/22
    var chatrooms = FirebaseFirestore.instance.collection("chatroom").where("chatroomID", arrayContains: postID);
    var snapshots = await chatrooms.get();
    for (var doc in snapshots.docs) {
      print(doc.id);
    }
  }
}
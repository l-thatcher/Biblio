import 'package:cloud_firestore/cloud_firestore.dart';

//these are my commonly used database features, there are still some within widgets that could be moved here for better code readability.
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
    FirebaseFirestore.instance.collection("chatroom").doc(chatRoomID).set(chatRoomMap);
  }

  addMessages(String chatroomID, messageMap) {
    FirebaseFirestore.instance.collection("chatroom").doc(chatroomID)
        .collection("chats").add(messageMap);
  }

  getMessages(String chatroomID) async {
    return FirebaseFirestore.instance.collection("chatroom").doc(chatroomID)
        .collection("chats").snapshots();
  }

  getChatRooms(userID){
    return FirebaseFirestore.instance.collection("chatroom").where("users", arrayContains: userID).snapshots();
  }

  deleteChatsWithUid(String postID) async {
    //delete function adapted from https://stackoverflow.com/questions/53089517/how-to-delete-all-documents-in-collection-in-firestore-with-flutter by user copsOnRoad accessed 17/01/22
    var chatrooms = FirebaseFirestore.instance.collection("chatroom").where("postID", isEqualTo: postID);
    chatrooms.get().then((snapshot) {
      for(DocumentSnapshot ds in snapshot.docs)
      {
        ds.reference.delete();
      }
    });
  }

  deletePost(String postID) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    posts
        .doc(postID)
        .delete();
  }
}
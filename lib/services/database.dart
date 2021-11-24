import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection('users').add(userMap);
  }

  newUserPost(postMap){
    FirebaseFirestore.instance.collection('posts').add(postMap);
  }

}
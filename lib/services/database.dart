import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods{

  uploadUserInfo(userMap, uuid){
    FirebaseFirestore.instance.collection('users').doc(uuid).set(userMap);
  }

  newUserPost(postMap){
    FirebaseFirestore.instance.collection('posts').add(postMap);
  }
}
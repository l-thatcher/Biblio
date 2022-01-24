import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('adding data through collection reference', () {

    test('user upload test', () async {
      final instance = FakeFirebaseFirestore();

      Map<String, dynamic> userInfoMap = {
        "email" : "email",
        "name" : "name",
        "course" : "course",
        "savedPosts" : [],
        "uuid" : "12345"
      };

      await instance.collection('users').doc("12345").set(userInfoMap);

      final snapshot = await instance.collection('users').get();

      expect(snapshot.docs.length, equals(1));
    });

    test("New post test", () async {
      final instance = FakeFirebaseFirestore();

      Map<String, String> postMap = {
        "name" : "name",
        "description" : "description",
        "condition" : "good",
        "price" : "Free",
        "course" : "chemistry",
        "image1" : "image1Url",
        "image2" : "image2Url",
        "image3" : "image3Url",
        "image4" : "image4Url",
        "userUuid" : "12345",
      };
      await instance.collection('posts').add(postMap);

      final snapshot = await instance.collection('posts').get();

      expect(snapshot.docs.length, equals(1));
    });

    test("Create chatroom", () async {
      final instance = FakeFirebaseFirestore();
      Map<String, dynamic> chatRoomMap = {
        "users" : ["abcde", "12345"],
        "chatroomID" : "abcde_12345",
        "image" : "image1Url",
        "chatName" : "chemistry",
        "postID" : "abcde"
      };
      instance.collection("chatroom").doc("abcde_12345").set(chatRoomMap);

      Map<String, dynamic> messageMap = {
        "message" : "test",
        "sentBy" : "12345",
        "time" : DateTime.now().microsecondsSinceEpoch
      };
      instance.collection("chatroom").doc("abcde_12345").collection("chats").add(messageMap);

      final snapshot = await instance.collection('chatroom').get();

      expect(snapshot.docs.length, equals(1));
    });
  });
}

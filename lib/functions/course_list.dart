import 'package:cloud_firestore/cloud_firestore.dart';


Future<List> CourseList(List coursePosts) async {
  await FirebaseFirestore.instance
      .collection('posts')
      .where('course', isEqualTo: "other")
      .limit(10)
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      coursePosts.add(doc["name"]);
    });
  });
  return coursePosts;
}






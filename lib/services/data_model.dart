import 'package:cloud_firestore/cloud_firestore.dart';

//this data model is used for the search feature in the database and returns a list of documents from the search
class DataModel {
  final String? condition;
  final String? course;
  final String? description;
  final String? image1;
  final String? image2;
  final String? image3;
  final String? image4;
  final String? name;
  final String? price;
  final String? userUuid;
  final String? postID;


  DataModel({this.condition, this.course, this.description, this.image1, this.image2, this.image3, this.image4, this.name, this.price, this.userUuid, this.postID});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold
  List<DataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
      snapshot.data() as Map<String, dynamic>;

      return DataModel(
          condition: dataMap['condition'],
          course: dataMap['course'],
          description: dataMap['description'],
          image1: dataMap['image1'],
          image2: dataMap['image2'],
          image3: dataMap['image3'],
          image4: dataMap['image4'],
          name: dataMap['name'],
          price: dataMap['price'],
          userUuid: dataMap['userUuid'],
          postID: snapshot.id);
    }).toList();
  }
}
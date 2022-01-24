import 'package:biblio_files/screens/personal_post_page.dart';
import 'package:biblio_files/screens/post_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';

class CourseRows extends StatefulWidget {
  final String? title;
  final String? userCourse;

  const CourseRows({Key? key, this.title, this.userCourse}) : super(key: key);

  @override
  State<CourseRows> createState() => _CourseRowsState();
}

//this loads rows of posts based on the course that the user is currently set to
class _CourseRowsState extends State<CourseRows> {

  final CollectionReference _productsRef = FirebaseFirestore.instance.collection("posts");

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.22,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              spreadRadius: 0.05,
              blurRadius: 20,
            )
          ]
      ),
      padding: const EdgeInsets.all(10),
      child: FutureBuilder<QuerySnapshot>(
        future: _productsRef.where('course', isEqualTo: widget.userCourse!)
            .get(),
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title ?? "", style: Constants.subtitleText,),
              Expanded(
                child: ListView(
                  //a list view with as many children as the snapshot has, which then shows the listings within the rows.
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    return GestureDetector(
                      onTap: (){
                        if(FirebaseAuth.instance.currentUser!.uid == document["userUuid"]){
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder:(context) => PersonalPostPage(postID: document.id),
                            ),
                          );
                        } else {
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder:(context) => PostPage(postID: document.id),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                                spreadRadius: 0.05,
                                blurRadius: 20,
                              )
                            ]
                        ),
                        margin: const EdgeInsets.all(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: Image.network(
                              "${document["image1"]}"
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )
            ],
          );
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

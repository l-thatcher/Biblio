import 'package:biblio_files/screens/personal_post_page.dart';
import 'package:biblio_files/screens/post_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';

import 'custom_image_button.dart';

class PostRows extends StatefulWidget {
  final String? title;
  final List<String>? postList;

  PostRows({this.title, this.postList});

  @override
  State<PostRows> createState() => _PostRowsState();
}

class _PostRowsState extends State<PostRows> {

  late Stream<QuerySnapshot> _productsRef;

  @override
  void initState() {
    _productsRef = FirebaseFirestore.instance.collection("posts").where(FieldPath.documentId, whereIn: widget.postList).snapshots();
    super.initState();
  }

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
      padding: EdgeInsets.all(10),
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _productsRef,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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


            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title ?? "", style: constants.subtitleText,),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data!.docs.map((document) {
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
                          margin: EdgeInsets.all(12),
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
          },
        ),
      ),
    );
  }
}

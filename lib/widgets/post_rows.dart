import 'package:biblio_files/screens/post_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';

import 'custom_image_button.dart';

class PostRows extends StatelessWidget {
  final CollectionReference _productsRef = FirebaseFirestore.instance.collection("posts");

  final String? title;

  PostRows({this.title});

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
        child: FutureBuilder<QuerySnapshot>(
          future: _productsRef.get(),
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
                  Text(title ?? "", style: constants.subtitleText,),
                  Expanded(
                    child: ListView(
                      // This next line does the trick.
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data!.docs.map((document) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => PostPage(postID: document.id)
                                ));
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
            }
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}

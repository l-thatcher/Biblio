import 'package:biblio_files/screens/edit_post_page.dart';
import 'package:biblio_files/screens/personal_post_page.dart';
import 'package:biblio_files/screens/post_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';



class PostListPreview extends StatelessWidget {
  String? image;
  String? name;
  String? postID;
  String? course;
  String? userUuid;

  PostListPreview({Key? key, this.image, this.name, this.postID, this.course, this.userUuid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(userUuid == FirebaseAuth.instance.currentUser!.uid){
          Navigator.push(context,
            MaterialPageRoute(
              builder:(context) => PersonalPostPage(postID: postID),
            ),
          );
        } else {
          Navigator.push(context,
            MaterialPageRoute(
              builder:(context) => PostPage(postID: postID),
            ),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.only(
            top: 5,
            bottom: 5,
        ),
        margin: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * 0.1,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                child: Image.network(image!)
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(name!, style: constants.subtitleText,),
                  Text(course!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

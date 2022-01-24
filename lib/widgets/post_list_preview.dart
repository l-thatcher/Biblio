import 'package:biblio_files/screens/personal_post_page.dart';
import 'package:biblio_files/screens/post_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';


//this returns a list of the users posts and displays them within tiles
class PostListPreview extends StatelessWidget {
  String? image;
  String? name;
  String? postID;
  String? course;
  String? userUuid;

  PostListPreview({Key? key, this.image, this.name, this.postID, this.course, this.userUuid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //link to the post that is being shown, the logic checks if the current user is the owner of the listing and although this should always be true it was simple to impliment from other pages and adds an extra
    //layer of security
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
                  Text(name!, style: Constants.subtitleText,),
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

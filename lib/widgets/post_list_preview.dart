import 'package:biblio_files/screens/edit_post_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class PostListPreview extends StatelessWidget {
  const PostListPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => EditPostPage(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
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
                width: 32,
                height: 32,
                child: Image(
                  image: AssetImage("lib/assets/sendMessage.png"),
                  fit: BoxFit.contain,
                  color: Theme.of(context).colorScheme.secondary,
                )
            ),
            Container(
              child: Text(
                "DUM<MY TEXT"
              ),
            ),
          ],
        ),
      ),
    );
  }
}

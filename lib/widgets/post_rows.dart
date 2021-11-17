import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';

import 'custom_image_button.dart';

class PostRows extends StatelessWidget {

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
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
              spreadRadius: 0.05,
              blurRadius: 20,
            )
          ]
      ),
      padding: EdgeInsets.all(10),
      child: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title ?? "", style: constants.subtitleText,),
              Expanded(
                child: ListView(
                  // This next line does the trick.
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    CustomImageButton(),
                    CustomImageButton(),
                    CustomImageButton(),
                    CustomImageButton(),
                    CustomImageButton(),
                    CustomImageButton(),
                    CustomImageButton(),
                    CustomImageButton(),
                    CustomImageButton(),
                  ],
                ),
              )
            ],
        ),
      ),
    );
  }
}

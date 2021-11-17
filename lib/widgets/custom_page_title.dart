import 'package:biblio_files/Styles/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomPageTitle extends StatelessWidget {

  final String? title;

  CustomPageTitle({this.title});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 56,
        left: 24,
        right: 24,
        bottom: 24,
      ),
      child: Text(title ?? "PAGETITLE", style: constants.titleText,),
    );
  }
}

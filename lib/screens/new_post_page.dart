import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:biblio_files/widgets/image_carousel.dart';
import 'package:biblio_files/widgets/post_details.dart';
import 'package:biblio_files/widgets/uploadImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class NewPostpage extends StatefulWidget {
  @override
  State<NewPostpage> createState() => _NewPostpageState();
}

class _NewPostpageState extends State<NewPostpage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: KeyboardDismissOnTap(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.92,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("lib/assets/backArrow.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                            child: CustomInput(text: "Name",)
                        ),
                        Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xff0e4c76),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            width: 30,
                            height: 30,
                            child: Image(
                              image: AssetImage("lib/assets/plusIcon.png"),
                              fit: BoxFit.contain,
                              color: Theme.of(context).colorScheme.secondary,
                            )
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 1,
                          constraints: BoxConstraints( maxWidth: MediaQuery.of(context).size.height * 0.5),
                          margin: EdgeInsets.all(5),
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
                          child: GridView.count(
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            children: [
                              UploadImage(),
                              UploadImage(),
                              UploadImage(),
                              UploadImage(),
                            ],
                          ),
                        ),
                        Expanded(child: PostDetails()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

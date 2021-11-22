import 'package:biblio_files/services/database.dart';
import 'package:biblio_files/widgets/condition_selector.dart';
import 'package:biblio_files/widgets/course_selector.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:biblio_files/widgets/image_carousel.dart';
import 'package:biblio_files/widgets/post_details.dart';
import 'package:biblio_files/widgets/price_selector.dart';
import 'package:biblio_files/widgets/upload_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class NewPostpage extends StatefulWidget {
  @override
  State<NewPostpage> createState() => _NewPostpageState();
}

class _NewPostpageState extends State<NewPostpage> {

  String name = "Not yet completed";
  String description = "Not yet completed";
  String condition = "Good";
  String price = "Not yet completed";
  String course = "Not yet completed";

  DatabaseMethods databaseMethods = new DatabaseMethods();

  Future<String?> _createPost() async {
    Map<String, String> postMap = {
      "name" : name,
      "description" : description,
      "condition" : condition,
      "price" : price,
      "course" : course,
      "image1" : "https://firebasestorage.googleapis.com/v0/b/biblio-27537.appspot.com/o/chemestry.jpg?alt=media&token=75582cbf-0a5e-4e86-8725-57e537fd0f27",
      "image2" : "https://firebasestorage.googleapis.com/v0/b/biblio-27537.appspot.com/o/chemestry.jpg?alt=media&token=75582cbf-0a5e-4e86-8725-57e537fd0f27",
      "image3" : "https://firebasestorage.googleapis.com/v0/b/biblio-27537.appspot.com/o/chemestry.jpg?alt=media&token=75582cbf-0a5e-4e86-8725-57e537fd0f27",
      "image4" : "https://firebasestorage.googleapis.com/v0/b/biblio-27537.appspot.com/o/chemestry.jpg?alt=media&token=75582cbf-0a5e-4e86-8725-57e537fd0f27",
    };


    databaseMethods.newUserPost(postMap);
  }

  void submitForm() async {
    _createPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: KeyboardDismissOnTap(
          child: SingleChildScrollView(
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
                        width: MediaQuery.of(context).size.width * 0.6,
                          child: CustomInput(text: "Name",
                          onChanged: (value) {
                            name = value;
                          },)
                      ),
                      GestureDetector(
                        onTap: _createPost,
                        child: Container(
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
                        ),
                      )
                    ],
                  ),
                ),
                Column(
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
                    CourseSelector(
                      onChanged: (value) {
                        course = value.toString();
                      },
                    ),
                    ConditionSelector(
                      onChanged: (value) {
                        condition = value;
                      },
                    ),
                    PriceSelector(
                      onChanged: (value) {
                        price = value;
                      },
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.24,
                        child: PostDetails(
                          onChanged: (value) {
                            description = value;
                          },
                        )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

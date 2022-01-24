import 'dart:io';

import 'package:biblio_files/services/database.dart';
import 'package:biblio_files/widgets/condition_selector.dart';
import 'package:biblio_files/widgets/course_selector.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:biblio_files/widgets/post_details.dart';
import 'package:biblio_files/widgets/price_selector.dart';
import 'package:biblio_files/widgets/upload_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:image_picker/image_picker.dart';


//this page was disigned to edit posts however I was unable to achieve this due to time constraints as I was having issues with the page and decided to focus elsewhere as a user can
//delete and remake a post.
class EditPostPage extends StatefulWidget {
  final String? postID;

  const EditPostPage({Key? key, this.postID}) : super(key: key);

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  String? name;
  String condition = "Good";
  String? description;
  String? price;
  String course = "Other";
  XFile? image1;
  XFile? image2;
  XFile? image3;
  XFile? image4;
  UploadImage uploadImg1 = UploadImage();
  UploadImage uploadImg2 = UploadImage();
  UploadImage uploadImg3 = UploadImage();
  UploadImage uploadImg4 = UploadImage();
  String image1Url = "";
  String image2Url = "";
  String image3Url = "";
  String image4Url = "";
  ConditionSelector conditionSelector = ConditionSelector();
  String? dropDownSet;
  CourseSelector courseSelector = CourseSelector();
  PriceSelector priceSelector = PriceSelector();
  PostDetails postDetails = PostDetails();


  DatabaseMethods databaseMethods = DatabaseMethods();
  bool formLoading = false;
  String errorMsg = "Something went wrong";
  final CollectionReference<Map<String, dynamic>> _productsRef = FirebaseFirestore.instance.collection("posts");

  @override
  void initState() {
    priceSelector = PriceSelector(
      priceSet: price,
      onChanged: (value) {
        price = value;
      },
    );
    courseSelector = CourseSelector(
      onChanged: (value) {
        course = value.toString();
      },
    );
    conditionSelector = ConditionSelector(
      dropDownSet: dropDownSet,
      onChanged: (value) {
        condition = value;
      },
    );
    postDetails = PostDetails(
      writtenText: description,
      onChanged: (value) {
        description = value;
      },
    );
    uploadImg1 = UploadImage(image: image1,);
    uploadImg2 = UploadImage(image: image2,);
    uploadImg3 = UploadImage(image: image3,);
    uploadImg4 = UploadImage(image: image4,);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _missingDetailsDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
              child: Text(errorMsg)
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> uploadFile(XFile? image) async {
    File file = File(image!.path);
    String url="";
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('userImages/${image.name}');
    UploadTask uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() async {
      url = await ref.getDownloadURL();
    });
    return url;
  }

  Future<String?> _createPost() async {
    if (name == null) {
      return "Please give this listing a name to upload it.";
    } else if (uploadImg1.image == null && uploadImg2.image == null && uploadImg3.image == null && uploadImg4.image == null){
      return "Please give this listing at least one image to upload it.";
    }
    else {
      try {
        if (uploadImg1.image != null){
          image1Url = await (uploadFile(uploadImg1.image));
        }
        if (uploadImg2.image != null){
          uploadFile(uploadImg2.image);
          image2Url = await (uploadFile(uploadImg2.image));
        }
        if (uploadImg3.image != null){
          uploadFile(uploadImg3.image);
          image3Url = await (uploadFile(uploadImg3.image));
        }
        if (uploadImg4.image != null){
          uploadFile(uploadImg4.image);
          image4Url = await (uploadFile(uploadImg4.image));
        }

        var currentUser = FirebaseAuth.instance.currentUser;
        String _name = name!;
        Map<String, String> postMap = {
          "name" : _name,
          "description" : description!,
          "condition" : condition,
          "price" : price!,
          "course" : course,
          "image1" : image1Url,
          "image2" : image2Url,
          "image3" : image3Url,
          "image4" : image4Url,
          "userUuid" : currentUser!.uid
        };
        databaseMethods.newUserPost(postMap);

        return null;
      } on Exception catch (e) {
        return (e.toString());
      }
    }
  }

  void submitForm() async {
    setState(() {
      formLoading = true;
    });
    String? createPostString = await _createPost();
    if(createPostString != null){
      errorMsg = createPostString;
      await _missingDetailsDialog();
      setState(() {
        formLoading = false;
      });
    } else {
      Navigator.pop(context);
    }

  }

  updatepage(documentData) {
    WidgetsFlutterBinding.ensureInitialized();
    setState(() {
      name = documentData["name"];
      image1 = XFile(documentData["image1"]);
      image2 = XFile(documentData["image2"]);
      image3 = XFile(documentData["image3"]);
      image4 = XFile(documentData["image4"]);
      course = documentData["course"];
      price = documentData["price"];
      condition = documentData["condition"];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: _productsRef.doc(widget.postID).get(),
              builder: (context, snapshot) {
                if(snapshot.hasError){
                  return Scaffold(
                    body: Center(
                      child: Text("Error: ${snapshot.error}"),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> documentData = snapshot.data!.data()!;
                  updatepage(documentData);

                  return KeyboardDismissOnTap(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5, bottom: 5),
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
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage("lib/assets/backArrow.png"),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: CustomInput(text: "Name",
                                      onChanged: (value) {
                                        name = value;
                                      },)
                                ),
                                GestureDetector(
                                  onTap: (
                                      submitForm
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xff0e4c76),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    width: 30,
                                    height: 30,
                                    child: Stack(
                                      children: [
                                        Visibility(
                                          visible: formLoading ? false : true,
                                          child: Image(
                                            image: const AssetImage("lib/assets/plusIcon.png"),
                                            fit: BoxFit.contain,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                        Visibility(
                                          visible: formLoading,
                                          child:const CircularProgressIndicator(
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      ],
                                    ),
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
                                margin: const EdgeInsets.all(5),
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  children: [
                                    uploadImg1,
                                    uploadImg2,
                                    uploadImg3,
                                    uploadImg4,
                                  ],
                                ),
                              ),
                              courseSelector,
                              conditionSelector,
                              priceSelector,
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.24,
                                child: postDetails,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

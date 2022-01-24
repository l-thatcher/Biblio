import 'package:biblio_files/screens/home_screen.dart';
import 'package:biblio_files/services/database.dart';
import 'package:biblio_files/widgets/custom_button.dart';
import 'package:biblio_files/widgets/image_carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';

//this is a near copy of the normal post page except you are given a bin option rather than a message option in the top corner.
class PersonalPostPage extends StatefulWidget {
  final String? postID;

  const PersonalPostPage({Key? key, this.postID}) : super(key: key);

  @override
  _PersonalPostPageState createState() => _PersonalPostPageState();
}

class _PersonalPostPageState extends State<PersonalPostPage> {
  final CollectionReference<Map<String, dynamic>> _productsRef = FirebaseFirestore.instance.collection("posts");
  final _userRef = FirebaseFirestore.instance.collection('users');
  DatabaseMethods databaseMethods = DatabaseMethods();


  AssetImage saveAsset = const AssetImage('lib/assets/savePost.png');
  bool saved = false;
  List<String> savedPosts = [];

  getSaved() async {
    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
      savedPosts = List.from(value.data()!['savedPosts']);
    });
  }

  @override
  initState() {
    getSaved();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void savePost() async {
    setState(() {
      saved = true;
      saveAsset = const AssetImage('lib/assets/savePostTabbed.png');
    });
    var currentUser = FirebaseAuth.instance.currentUser;
    var idList = [widget.postID];
    _userRef.doc(currentUser!.uid).update({
      'savedPosts' : FieldValue.arrayUnion(idList)});
    getSaved();
  }

  Future<void> _deleteConfirm() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const SingleChildScrollView(
              child: Text("Are you sure you want to delete this post?")
          ),
          actions: <Widget>[
            Row(
              children: [
                CustomButton(text: "No", width: MediaQuery.of(context).size.width * 0.25, outlined: true, onPressed: () {
                  Navigator.of(context).pop();
                },),
                CustomButton(text: "Yes", width: MediaQuery.of(context).size.width * 0.25, onPressed: () {
                  databaseMethods.deleteChatsWithUid(widget.postID!);
                  databaseMethods.deletePost(widget.postID!);
                  Navigator.push(context,
                    MaterialPageRoute(
                      builder:(context) => const HomeScreen(),
                    ),
                  );
                },),
              ],
            )
          ],
        );
      },
    );
  }

  void unSavePost() async {
    setState(() {
      saved = false;
      saveAsset = const AssetImage('lib/assets/savePost.png');
    });
    var currentUser = FirebaseAuth.instance.currentUser;
    var idList = [widget.postID];
    _userRef.doc(currentUser!.uid).update({
      'savedPosts' : FieldValue.arrayRemove(idList)});
    getSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // future builder fix from https://stackoverflow.com/questions/68432119/error-the-method-data-isnt-defined-for-the-class-object accessed 20/11/21
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

                  if (savedPosts.contains(widget.postID)) {
                    saved = true;
                    saveAsset = const AssetImage('lib/assets/savePostTabbed.png');
                  } else {
                    saved = false;
                    saveAsset = const AssetImage('lib/assets/savePost.png');
                  }

                  Map<String, dynamic> documentData = snapshot.data!.data()!;

                  List imageList = [];

                  if(documentData["image1"] != "") {
                    imageList.add(documentData["image1"]);
                  }
                  if(documentData["image2"] != "") {
                    imageList.add(documentData["image2"]);
                  }
                  if(documentData["image3"] != "") {
                    imageList.add(documentData["image3"]);
                  }
                  if(documentData["image4"] != "") {
                    imageList.add(documentData["image4"]);
                  }


                  return SafeArea(
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
                                  width: 15,
                                  height: 15,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("lib/assets/backArrow.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              Text(documentData["name"], style: Constants.subtitleText,),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      saved ? unSavePost() : savePost();
                                    },
                                    child: SizedBox(
                                        width: 45,
                                        height: 45,
                                        child: Image(
                                          image: saveAsset,
                                          fit: BoxFit.contain,
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _deleteConfirm();
                                    },
                                    child: SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: Image(
                                          image: const AssetImage("lib/assets/deletePost.png"),
                                          fit: BoxFit.contain,
                                          color: Theme.of(context).colorScheme.secondary,
                                        )
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ImageCarousel(imageList: imageList,),
                              Expanded(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(10),
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
                                  child: Stack(
                                    children: [
                                      Container(
                                          alignment: const Alignment(-1, -1),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text("Description", style: Constants.regularText,),
                                              Expanded(
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(15),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.25),
                                                            spreadRadius: 0.05,
                                                            blurRadius: 20,
                                                          )
                                                        ]
                                                    ),
                                                    width: MediaQuery.of(context).size.width * 1,
                                                    padding: const EdgeInsets.all(15),
                                                    margin: const EdgeInsets.only(
                                                      top: 5,
                                                      left: 5,
                                                      right: 5,
                                                      bottom: 25,
                                                    ),
                                                    child: Text("${documentData["description"]}")
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                      Container(
                                          alignment: const Alignment(-0.9, 1),
                                          child: Text("${documentData["price"]}", style: Constants.regularText,),
                                      ),
                                      Container(
                                        alignment: const Alignment(1, -1),
                                        child: Text("Condition: ${documentData["condition"]}", style: Constants.regularText,),
                                      ),
                                      Container(
                                        alignment: const Alignment(0, 1),
                                        child: Text("Course: ${documentData["course"]}", style: Constants.regularText,),
                                      ),
                                      Container(
                                        alignment: const Alignment(1, 1),
                                        child: const Text("Location: ", style: Constants.regularText,),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
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

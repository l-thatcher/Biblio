import 'package:biblio_files/widgets/image_carousel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';


class PostPage extends StatefulWidget {


  final String? postID;

  PostPage({this.postID});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final CollectionReference<Map<String, dynamic>> _productsRef = FirebaseFirestore.instance.collection("posts");

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

                  Map<String, dynamic> documentData = snapshot.data!.data()!;

                  List imageList = documentData["images"];

                  return SafeArea(
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
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("lib/assets/backArrow.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              Text(documentData["name"], style: constants.subtitleText,),
                              Row(
                                children: [
                                  Container(
                                      width: 45,
                                      height: 45,
                                      child: Image(
                                        image: AssetImage("lib/assets/savePost.png"),
                                        fit: BoxFit.contain,
                                        color: Theme.of(context).colorScheme.secondary,
                                      )
                                  ),
                                  Container(
                                      width: 32,
                                      height: 32,
                                      child: Image(
                                        image: AssetImage("lib/assets/sendMessage.png"),
                                        fit: BoxFit.contain,
                                        color: Theme.of(context).colorScheme.secondary,
                                      )
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
                                  width: MediaQuery.of(context).size.width * 1,
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.all(10),
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
                                          alignment: Alignment(-1, -1),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Description", style: constants.regularText,),
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
                                                    padding: EdgeInsets.all(15),
                                                    margin: EdgeInsets.only(
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
                                          alignment: Alignment(-0.9, 1),
                                          child: Text("£${documentData["price"]}", style: constants.regularText,),
                                      ),
                                      Container(
                                        alignment: Alignment(1, -1),
                                        child: Text("Condition: ${documentData["condition"]}", style: constants.regularText,),
                                      ),
                                      Container(
                                        alignment: Alignment(0, 1),
                                        child: Text("Course: ", style: constants.regularText,),
                                      ),
                                      Container(
                                        alignment: Alignment(1, 1),
                                        child: Text("Location: ", style: constants.regularText,),
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
                return Scaffold(
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

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
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("lib/assets/defaultProfilePic.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height * 0.5,
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
                                child: Image.network(
                                    "${documentData["images"][0]}"
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.32,
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
                                child: Column(
                                  children: [
                                    Text("PRoduct name"),
                                    Text("Description"),
                                    Text("Produict price"),
                                    Text("Condition"),
                                    Text("COurse"),
                                    Text("Location")
                                  ],
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

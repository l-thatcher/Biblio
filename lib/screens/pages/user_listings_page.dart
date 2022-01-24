import 'package:biblio_files/screens/new_post_page.dart';
import 'package:biblio_files/widgets/custom_image_button.dart';
import 'package:biblio_files/widgets/post_list_preview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:biblio_files/Styles/Constants.dart';



class UserListingsPage extends StatelessWidget {
  UserListingsPage({Key? key}) : super(key: key);
  final Stream<QuerySnapshot> _productsRef = FirebaseFirestore.instance.collection("posts").where('userUuid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots();


  //this shows the user a list of their own posts on the app.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _productsRef,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasError){
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 15,
                  left: 18,
                  right: 24,
                  bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.listingsTitle, style: Constants.titleText,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => const NewPostpage(),
                          ),
                        );
                      },
                      child: const SizedBox(
                          height: 63,
                          child: CustomImageButton(image: 'lib/assets/plusIcon.png', outlined: true,)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    topLeft: Radius.circular(15),
                                  ),
                                  color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                                ),
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Center(child: Text(AppLocalizations.of(context)!.listingsSubTitle))
                            ),
                            Expanded(
                              child: ListView(
                                children: snapshot.data!.docs.map((document) {
                                  //a postListPreview widget is used to show each of the posts.
                                  return PostListPreview(image: document["image1"], name: document["name"], postID: document.id, course: document["course"], userUuid: document["userUuid"],);
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}


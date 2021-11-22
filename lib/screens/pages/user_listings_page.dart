import 'package:biblio_files/screens/new_post_page.dart';
import 'package:biblio_files/widgets/custom_image_button.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:biblio_files/widgets/postListPreview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:biblio_files/Styles/constants.dart';



class UserListingsPage extends StatelessWidget {
  const UserListingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.925,
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
                    Text(AppLocalizations.of(context)!.listingsTitle, style: constants.titleText,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => NewPostpage(),
                          ),
                        );
                      },
                      child: Container(
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
                        margin: EdgeInsets.only(left: 15, right: 15, bottom: 89),
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
                                  borderRadius: BorderRadius.only(
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
                                children: const <Widget>[
                                  PostListPreview(),
                                  PostListPreview(),
                                  PostListPreview(),
                                ],
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
        ),
      ),
    );
  }
}

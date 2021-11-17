import 'package:biblio_files/widgets/custom_image_button.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:biblio_files/Styles/constants.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class Searchpage extends StatelessWidget {
  const Searchpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //single child scroll view used to allow the keyboard to cover the screen, from https://stackoverflow.com/questions/46551268/when-the-keyboard-appears-the-flutter-widgets-resize-how-to-prevent-this by user Duncan Jones accessed 17/11/21
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 15,
                left: 18,
                right: 24,
                bottom: 24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.searchTitle, style: constants.titleText,),
                  Container(
                    height: 75,
                    padding: const EdgeInsets.only(top: 10,),
                      child: CustomImageButton(image: 'lib/assets/icons/burgerIcon.png', outlined: true,)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 80,
                left: 15,
                right: 15,
              ),
              child : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomInput(
                    text : ((AppLocalizations.of(context)!.searchTitle) + "..."),
                    primaryInput: false,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    margin: EdgeInsets.only(top: 20),
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
                            padding: const EdgeInsets.only(
                              top: 10,
                              bottom: 10,
                            ),
                            child: Text("Search history")
                        ),
                        Expanded(
                          child: ListView(
                            children: const <Widget>[
                              ListTile(
                                leading: Icon(Icons.map),
                                title: Text('Map'),
                              ),
                              ListTile(
                                leading: Icon(Icons.photo_album),
                                title: Text('Album'),
                              ),
                              ListTile(
                                leading: Icon(Icons.phone),
                                title: Text('Phone'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

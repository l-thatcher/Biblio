import 'package:biblio_files/widgets/custom_image_button.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:biblio_files/Styles/constants.dart';

class Searchpage extends StatelessWidget {
  const Searchpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //single child scroll view used to allow the keyboard to cover the screen, from https://stackoverflow.com/questions/46551268/when-the-keyboard-appears-the-flutter-widgets-resize-how-to-prevent-this by user Duncan Jones accessed 17/11/21
    return SafeArea(
      child: Column(
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
                Text(AppLocalizations.of(context)!.searchTitle, style: constants.titleText,),
                Container(
                  height: 63,
                    child: CustomImageButton(image: 'lib/assets/icons/burgerIcon.png', outlined: true,)),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomInput(
                  text : ((AppLocalizations.of(context)!.searchTitle) + "..."),
                  primaryInput: false,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
                            child: Center(child: Text(AppLocalizations.of(context)!.searchSubTitle))
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

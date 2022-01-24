import 'package:biblio_files/screens/chat_pages/contacts_page.dart';
import 'package:biblio_files/widgets/custom_image_button.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:biblio_files/widgets/post_rows.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:biblio_files/Styles/constants.dart';

class Messagespage extends StatelessWidget {
  const Messagespage({Key? key}) : super(key: key);


  //this page shows the users open chats with other users
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        //there is some basic decoration done, then the page shows the "contacts page" in the center
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 15,
              left: 18,
              right: 24,
              bottom: 10,
            ),
            child: Text(AppLocalizations.of(context)!.messagesTitle, style: constants.titleText,),
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
              padding: const EdgeInsets.all(7),
              child: ContactsPage()
              ),
            ),
        ],
      ),
    );
  }
}

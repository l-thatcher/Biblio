import 'package:biblio_files/widgets/custom_image_button.dart';
import 'package:biblio_files/widgets/custom_page_title.dart';
import 'package:biblio_files/widgets/post_rows.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:biblio_files/Styles/constants.dart';


class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
          padding: const EdgeInsets.only(
            top: 15,
            left: 18,
            right: 24,
            bottom: 24,
          ),
          child: const Text("Home", style: constants.titleText,),
          ),
          Container(
            padding: const EdgeInsets.only(
              top: 80,
              left: 28,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PostRows(title: "Recently Viewed",),
                PostRows(title: "Saved from earlier",),
                PostRows(title: "Your course nearby",),
              ],
            ),
          )
        ],
      ),
    );
  }
}

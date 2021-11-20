import 'package:biblio_files/widgets/custom_image_button.dart';
import 'package:biblio_files/widgets/custom_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';



//chat functionality adapted from https://www.youtube.com/watch?v=kcLt5IHOFRI&t=1251s - first accessed 17/11/21
class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardDismissOnTap(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 30,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                },
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("lib/assets/backArrow.png"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              Text("data", style: constants.titleText,),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("lib/assets/defaultProfilePic.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 5,
                color: Theme.of(context).colorScheme.secondary,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 30,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        right: 25,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              spreadRadius: 0.05,
                              blurRadius: 20,
                            )
                          ]
                      ),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                  constraints: BoxConstraints(
                                    minHeight: MediaQuery.of(context).size.height * 0.09,
                                    maxHeight: MediaQuery.of(context).size.height * 0.15,
                                  ),
                                  child: CustomInput(text : AppLocalizations.of(context)!.messageHint,)),
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("lib/assets/frontArrow.png"),
                                  fit: BoxFit.contain,
                                ),
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

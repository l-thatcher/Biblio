import 'dart:async';

import 'package:biblio_files/screens/pages/home_page.dart';
import 'package:biblio_files/screens/pages/messages_page.dart';
import 'package:biblio_files/screens/pages/profile_page.dart';
import 'package:biblio_files/screens/pages/search_page.dart';
import 'package:biblio_files/screens/pages/post_page.dart';
import 'package:biblio_files/widgets/bottom_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {

  late PageController _tabPageController;
  late StreamSubscription<bool> keyboardSubscription;

  int selectedPage = 0;
  bool barVisible = true;

  @override
  void initState() {
    _tabPageController = PageController();
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();

    // keyboard visibility checker from https://pub.dev/packages/flutter_keyboard_visibility accessed 15/11/21
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        barVisible = !visible;
      });
    });

  }

  @override
  void dispose() {
    _tabPageController = PageController();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabPageController,
                  onPageChanged: (num) {
                    setState(() {
                      selectedPage = num;
                    });
                  },
                  children: [
                    Homepage(),
                    Searchpage(),
                    Postpage(),
                    Messagespage(),
                    Profilepage()
                  ],
                ),
              ),
              Visibility(
                visible: barVisible,
                child: BottomNavbar(
                  selectedTab: selectedPage,
                  changePage: (num) {
                    _tabPageController.animateToPage(num,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOutQuart);
                  },
                ),
              ),
            ],
          ),
      ),
    );
  }
}

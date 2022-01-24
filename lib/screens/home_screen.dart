import 'dart:async';

import 'package:biblio_files/screens/pages/home_page.dart';
import 'package:biblio_files/screens/pages/messages_page.dart';
import 'package:biblio_files/screens/pages/profile_page.dart';
import 'package:biblio_files/screens/pages/search_page.dart';
import 'package:biblio_files/screens/pages/user_listings_page.dart';
import 'package:biblio_files/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';


//this page provides the base for each of the home widgets, and displays the custom bottom nav bar at the bottom
class HomeScreen extends StatefulWidget {
  final int? selectedPage;

  const HomeScreen({Key? key, this.selectedPage}) : super(key: key);

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {

  late PageController _tabPageController;
  late StreamSubscription<bool> keyboardSubscription;

  int _selectedPage = 0;
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
    keyboardSubscription.cancel();
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
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabPageController,
                  onPageChanged: (number) {
                    setState(() {
                      _selectedPage = number;
                    });
                  },
                  children: [
                    //each page used to populate the content of this one
                    const Homepage(),
                    const Searchpage(),
                    UserListingsPage(),
                    const Messagespage(),
                    const Profilepage()
                  ],
                ),
              ),
              Visibility(
                visible: barVisible,
                child: BottomNavbar(
                  selectedTab: widget.selectedPage ?? _selectedPage,
                  changePage: (number) {
                    _tabPageController.animateToPage(number,
                        duration: const Duration(milliseconds: 300),
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

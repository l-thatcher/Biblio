import 'package:biblio_files/widgets/bottom_navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late PageController _tabPageController;
  int selectedPage = 0;

  @override
  void initState() {
    _tabPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabPageController = PageController();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Container(
                    child: Center(
                      child: Text("Homepage"),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text("Search Page"),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text("New Post"),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text("Message Page"),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Text("profile Page"),
                    ),
                  ),
                ],
              ),
            ),
            BottomNavbar(
              selectedTab: selectedPage,
              changePage: (num) {
                _tabPageController.animateToPage(num,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOutQuart);
              },
            ),
          ],
        ),
    );
  }
}

import 'package:biblio_files/Styles/constants.dart';
import 'package:biblio_files/widgets/bottom_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              child: Text("logout"),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
            ),
            BottomNavbar(),
          ],
        ),
    );
  }
}

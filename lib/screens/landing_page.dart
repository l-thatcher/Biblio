import 'package:biblio_files/constants.dart';
import 'package:biblio_files/screens/home_page.dart';
import 'package:biblio_files/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              if (streamSnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${streamSnapshot.error}"),
                  ),
                );
              }

              if(streamSnapshot.connectionState == ConnectionState.active) {
                Object? user = streamSnapshot.data;

                if(user == null) {
                  return LoginPage();
                } else {
                  return HomePage();
                }
              }
              return Scaffold(
                body: Center(
                  child: Text(
                    "Checking Authentication...",
                    style: constants.regularText,
                  ),
                ),
              );
            },
          );
        }

        return Scaffold(
          body: Center(
            child: Text(
              "Initializing app...",
              style: constants.regularText,
            ),
          ),
        );
      },
    );
  }
}

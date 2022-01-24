import 'package:biblio_files/Styles/constants.dart';
import 'package:biblio_files/screens/home_screen.dart';
import 'package:biblio_files/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  //this is the page that is opened by the main function, it checks if the user is authenticated and sends them to the correct page accordingly, it is also where firestore initialization takes place
  LandingPage({Key? key}) : super(key: key);

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
                  return const LoginPage();
                } else {
                  return const HomeScreen();
                }
              }
              return const Scaffold(
                body: Center(
                  child: Text(
                    "Checking Authentication...",
                    style: Constants.regularText,
                  ),
                ),
              );
            },
          );
        }

        return const Scaffold(
          body: Center(
            child: Text(
              "Initializing app...",
              style: Constants.regularText,
            ),
          ),
        );
      },
    );
  }
}

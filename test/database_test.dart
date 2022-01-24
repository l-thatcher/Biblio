// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:biblio_files/screens/home_screen.dart';
import 'package:biblio_files/screens/landing_page.dart';
import 'package:biblio_files/screens/pages/home_page.dart';
import 'package:biblio_files/services/database.dart';
import 'package:biblio_files/widgets/bottom_navbar.dart';
import 'package:biblio_files/widgets/post_rows.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:biblio_files/main.dart';

void main() {
  testWidgets('database test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: BottomNavbar(),
      ),
    ));
    expect(BottomNavbar(), findsOneWidget);
  });
}

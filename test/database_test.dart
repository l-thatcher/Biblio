

import 'package:biblio_files/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('database test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: BottomNavbar(),
      ),
    ));
    expect(const BottomNavbar(), findsOneWidget);
  });
}

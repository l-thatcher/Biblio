import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomNavbarBtn(),
          BottomNavbarBtn(),
          BottomNavbarBtn(),
          BottomNavbarBtn(),
        ],
      ),
    );
  }
}

class BottomNavbarBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      child: Image(
        image: AssetImage(
            "lib/assets/icons/homeIcon.png"
        ),
        fit: BoxFit.contain,
      ),
    );
  }
}

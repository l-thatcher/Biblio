import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class BottomNavbar extends StatefulWidget {

  final int? selectedTab;
  final Function(int)? changePage;

  BottomNavbar({this.selectedTab, this.changePage});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

//this is the bottom navbar that displays at the bottom of the home screen

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    _selectedTab = widget.selectedTab ?? 0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
            spreadRadius: 0.05,
            blurRadius: 30,
          )
        ]
      ),
      child: Row(
        //this is each of the symbols which change depending on if they are selected or not
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomNavbarBtn(
            image: "lib/assets/icons/homeIcon.png",
            selected: _selectedTab == 0 ? true: false,
            onPressed: () {
              widget.changePage!(0);
            },
          ),
          BottomNavbarBtn(
            image: "lib/assets/icons/searchIcon.png",
            selected: _selectedTab == 1 ? true: false,
            onPressed: () {
              widget.changePage!(1);
            },
          ),
          BottomNavbarBtn(
            image: "lib/assets/icons/postIcon.png",
            selected: _selectedTab == 2 ? true: false,
            onPressed: () {
              widget.changePage!(2);
            },
          ),
          BottomNavbarBtn(
            image: "lib/assets/icons/messagesIcon.png",
            selected: _selectedTab == 3 ? true: false,
            onPressed: () {
              widget.changePage!(3);
            },
          ),
          BottomNavbarBtn(
            image: "lib/assets/icons/profileIcon.png",
            selected: _selectedTab == 4 ? true: false,
            onPressed: () {
              widget.changePage!(4);
            },
          ),
        ],
      ),
    );
  }
}

//each button is made using this widget
class BottomNavbarBtn extends StatelessWidget {

  final String? image;
  final bool? selected;
  final VoidCallback? onPressed;

  BottomNavbarBtn({this.image, this.selected, this.onPressed});

  @override
  Widget build(BuildContext context) {

    String _image = image ?? 'lib/assets/exclamation.png';
    bool _selected = selected ?? false;
    bool _onPressed = selected ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: _selected ? Theme.of(context).colorScheme.secondary : Colors.transparent,
              width: 2
            )
          )
        ),
        child: Image(
          image: AssetImage(_image),
          fit: BoxFit.cover,
          width:  _selected ? 42 : 32,
          height:  _selected ? 42 : 32,
          color: _selected ? Theme.of(context).colorScheme.secondary : Colors.black,
        ),
      ),
    );
  }
}

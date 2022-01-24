import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


// basic widget for selecting the course for the book or for the user
class CourseSelector extends StatelessWidget {

  final Function(dynamic)? onChanged;
  //the courses are loaded from a list so can easily be added to or taken away
  final courseOptions = ['Other', 'Physics', 'Chemistry', 'Computer Science', 'Maths', 'Engineering'];

  CourseSelector({this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.only(
          left: 15,
          right: 15
      ),
      child: Container(
        //the text drop down field allowed for user to search or scroll to find their course
        child: TextDropdownFormField(
          onChanged: onChanged,
          options: courseOptions,
          decoration: InputDecoration(
            constraints: BoxConstraints(maxHeight: 60),
            border: InputBorder.none,
            suffixIcon: Icon(Icons.arrow_drop_down),
            labelText: "Course",),
          dropdownHeight: 200,
        ),
      ),
    );
  }
}

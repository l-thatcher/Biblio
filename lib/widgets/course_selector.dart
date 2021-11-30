import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseSelector extends StatelessWidget {

  final Function(dynamic)? onChanged;
  final courseOptions = ['Other', 'Physics', 'Chemestry', 'Computer Science', 'Maths', 'Engineering'];

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
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
              spreadRadius: 0.05,
              blurRadius: 20,
            )
          ]
      ),
      child: Container(
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

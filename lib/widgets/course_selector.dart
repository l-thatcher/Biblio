import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/material.dart';


// basic widget for selecting the course for the book or for the user
class CourseSelector extends StatelessWidget {

  final Function(dynamic)? onChanged;
  //the courses are loaded from a list so can easily be added to or taken away
  final courseOptions = ['Other', 'Physics', 'Chemistry', 'Computer Science', 'Maths', 'Engineering'];

  CourseSelector({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.only(
          left: 15,
          right: 15
      ),
      child: TextDropdownFormField(
        onChanged: onChanged,
        options: courseOptions,
        decoration: const InputDecoration(
          constraints: BoxConstraints(maxHeight: 60),
          border: InputBorder.none,
          suffixIcon: Icon(Icons.arrow_drop_down),
          labelText: "Course",),
        dropdownHeight: 200,
      ),
    );
  }
}

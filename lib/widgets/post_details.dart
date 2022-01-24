import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

//the text on the new post page is done here
class PostDetails extends StatelessWidget {

  final Function(String)? onChanged;
  String? writtenText;

  PostDetails({this.onChanged, this.writtenText});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
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
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Text("Description...", style: constants.regularText,),
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xff2C3F576F)
            ),
            padding: EdgeInsets.only(
                left: 15,
                right: 15
            ),
            margin: EdgeInsets.only(
              top: 5,
              left: 5,
              right: 5,
            ),
            child: TextFormField(
              initialValue: writtenText,
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Aa...",
              ),
              style: constants.regularText,
            ),
          ),
        ],
      ),
    );
  }
}







// Container(
//   alignment: Alignment(-0.9, 1.05),
//   child: Text("Price: ", style: constants.regularText,),
// ),
// Container(
//   alignment: Alignment(-0.65, 1.05),
// ),
// Container(
//   alignment: Alignment(0.4, -1),
//   child: Text("Condition:", style: constants.regularText,),
// ),
// Container(
//   alignment: Alignment(1, -1.18),
//   child: DropdownButtonHideUnderline(
//     child: DropdownButton<String>(
//       value: dropdownValue,
//       style: TextStyle(fontSize: 15, color: Colors.black),
//       onChanged: (String? newValue) {
//         setState(() {
//           dropdownValue = newValue!;
//         });
//       },
//       items: <String>['Bad', 'Okay', 'Good', 'Perfect']
//           .map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     ),
//   ),
// ),
// Container(
//   alignment: Alignment(0.5, 1),
//   child: Text("Course: ", style: constants.regularText,),
// ),
//   ],
// ),
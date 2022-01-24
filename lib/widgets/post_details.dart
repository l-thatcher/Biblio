import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';

//the text on the new post page is done here
class PostDetails extends StatelessWidget {

  final Function(String)? onChanged;
  final String? writtenText;

  const PostDetails({Key? key, this.onChanged, this.writtenText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(10),
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
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const Text("Description...", style: Constants.regularText,),
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xff2C3F576F)
            ),
            padding: const EdgeInsets.only(
                left: 15,
                right: 15
            ),
            margin: const EdgeInsets.only(
              top: 5,
              left: 5,
              right: 5,
            ),
            child: TextFormField(
              initialValue: writtenText,
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Aa...",
              ),
              style: Constants.regularText,
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
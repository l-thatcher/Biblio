import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';


class PostDetails extends StatefulWidget {
  const PostDetails({Key? key}) : super(key: key);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {

  String dropdownValue = "Good";
  var priceController = new MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', leftSymbol: '\£ ');


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
              bottom: 8,
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Aa...",
              ),
              style: constants.regularText,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [
                  Text("Price: ", style: constants.regularText,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Text("Condition: ", style: constants.regularText,),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      style: TextStyle(fontSize: 15, color: Colors.black),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['Bad', 'Okay', 'Good', 'Perfect']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

            ],
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
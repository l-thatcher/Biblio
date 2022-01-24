import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';

class ConditionSelector extends StatefulWidget {

  final ValueChanged<String>? onChanged;
  String? dropDownSet;
  ConditionSelector({Key? key, this.onChanged, this.dropDownSet}) : super(key: key);


  @override
  State<ConditionSelector> createState() => _ConditionSelectorState();
}

//a widget to select the condition of the book when making a new listing
class _ConditionSelectorState extends State<ConditionSelector> {
  late String dropdownValue = widget.dropDownSet ?? "Good";


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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Condition: ", style: constants.regularText,),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: dropdownValue,
              style: TextStyle(fontSize: 15, color: Colors.black),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  widget.dropDownSet = newValue;
                });
                //onChanged value adapted from https://stackoverflow.com/questions/54694169/returning-data-from-a-stateful-widget-in-flutter by user Umar Farooq accessed 22/11/21
                widget.onChanged!(dropdownValue);
              },
              //the options are loaded from a list so this can be easily changed if ever needed
              items: <String>['Bad', 'Okay', 'Good', 'Perfect']
                  .map<DropdownMenuItem<String>>((String value) {
                    //using the dropdown menu library made development much smoother
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

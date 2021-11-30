import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class PriceSelector extends StatelessWidget {


  final Function(String)? onChanged;
  String? priceSet;
  var priceController = new MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', leftSymbol: '\£ ');

  PriceSelector({this.onChanged, this.priceSet});

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Price: ", style: constants.regularText,),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextFormField(
              initialValue: priceSet,
              onChanged: onChanged,
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
    );
  }
}

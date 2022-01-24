import 'package:flutter/material.dart';
import 'package:biblio_files/Styles/constants.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class PriceSelector extends StatelessWidget {


  //the price input for the new post page, the MoneyMaskedTextController library makes it easy to take money values as a user input rather than try and format the numbers myself

  final Function(String)? onChanged;
  final String? priceSet;
  var priceController = MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',', leftSymbol: '£');

  PriceSelector({Key? key, this.onChanged, this.priceSet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.only(
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
          const Text("Price: ", style: Constants.regularText,),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: TextFormField(
              initialValue: priceSet,
              onChanged: onChanged,
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

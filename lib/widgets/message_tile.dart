import 'package:biblio_files/Styles/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final bool fromMe;
  const MessageTile({Key? key, required this.message, required this.fromMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      margin: EdgeInsets.all(10),
      alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: fromMe ? Colors.white : Colors.blueGrey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: fromMe ? Radius.circular(12) : Radius.circular(0),
                bottomRight: fromMe ? Radius.circular(0) : Radius.circular(12),),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                spreadRadius: 0.05,
                blurRadius: 30,
              )
            ]
        ),
        child: Text(message, style: fromMe ? constants.myMsg : constants.otherMsg,),
      ),
    );
  }
}

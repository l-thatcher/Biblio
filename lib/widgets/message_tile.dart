import 'package:biblio_files/Styles/constants.dart';
import 'package:flutter/material.dart';

//messages in the chat screen are shown within these widgets
class MessageTile extends StatelessWidget {
  final String message;
  //options are set depending on if the user has sent or recieved the message
  final bool fromMe;
  const MessageTile({Key? key, required this.message, required this.fromMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      margin: const EdgeInsets.all(10),
      alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: fromMe ? Colors.white : Colors.blueGrey,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: fromMe ? const Radius.circular(12) : const Radius.circular(0),
                bottomRight: fromMe ? const Radius.circular(0) : const Radius.circular(12),),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                spreadRadius: 0.05,
                blurRadius: 30,
              )
            ]
        ),
        child: Text(message, style: fromMe ? Constants.myMsg : Constants.otherMsg,),
      ),
    );
  }
}

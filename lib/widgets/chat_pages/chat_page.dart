import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//chat functionality adapted from https://www.youtube.com/watch?v=kcLt5IHOFRI&t=1251s - first accessed 17/11/21
class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text("TEST"),
      ),
    );
  }
}

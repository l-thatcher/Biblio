import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UploadImage extends StatefulWidget {
  const UploadImage({Key? key}) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  final String image = "lib/assets/uploadImage.png";



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: GestureDetector(
          child: Image(
            image: AssetImage(image),
            fit: BoxFit.contain,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}

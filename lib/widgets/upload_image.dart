import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class UploadImage extends StatefulWidget {
  XFile? image;
  UploadImage({Key? key, this.image}) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {

  final uploadImage = "lib/assets/uploadImage.png";
  //image upload adapted from https://rrtutors.com/tutorials/imagepicker-flutter accessed 24/11/21

  Future<void> _getInputMethod() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose option",style: TextStyle(color: Colors.blue),),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Divider(height: 1,color: Colors.blue,),
                ListTile(
                  onTap: (){
                    _openGallery(context);
                  },
                  title: Text("Gallery"),
                  leading: Icon(Icons.account_box,color: Colors.blue,),
                ),

                Divider(height: 1,color: Colors.blue,),
                ListTile(
                  onTap: (){
                    _openCamera(context);
                  },
                  title: Text("Camera"),
                  leading: Icon(Icons.camera,color: Colors.blue,),
                ),
              ],
            ),
          ),);
      },
    );
  }

  void _openGallery(BuildContext context) async{
    final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      widget.image = pickedFile!;
    });
    Navigator.pop(context);
  }

  void _openCamera(BuildContext context)  async{
    final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      widget.image = pickedFile!;
    });
    Navigator.pop(context);
  }


  // Future<void> uploadFile(String filePath) async {
  //   try {
  //     await firebase_storage.FirebaseStorage.instance
  //         .ref('userImages/')
  //         .putFile(imageFile);
  //   } on firebase_storage.FirebaseException catch (e) {
  //     print( e.toString() );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Center(
        child: GestureDetector(
          onTap: _getInputMethod,
          child: Image(
            image: widget.image != null ? FileImage(File(widget.image!.path)) as ImageProvider : AssetImage(uploadImage),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

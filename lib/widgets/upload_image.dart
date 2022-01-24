import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class UploadImage extends StatefulWidget {
  XFile? image;
  UploadImage({Key? key, this.image}) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}


//allows the user to upload images to the new post page
class _UploadImageState extends State<UploadImage> {

  final uploadImage = "lib/assets/uploadImage.png";
  //image upload adapted from https://rrtutors.com/tutorials/imagepicker-flutter accessed 24/11/21

  //pop up to allow the user to choose gallery or camera for the image upload
  Future<void> _getInputMethod() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose option",style: TextStyle(color: Colors.blue),),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const Divider(height: 1,color: Colors.blue,),
                ListTile(
                  onTap: (){
                    _openGallery(context);
                  },
                  title: const Text("Gallery"),
                  leading: const Icon(Icons.account_box,color: Colors.blue,),
                ),

                const Divider(height: 1,color: Colors.blue,),
                ListTile(
                  onTap: (){
                    _openCamera(context);
                  },
                  title: const Text("Camera"),
                  leading: const Icon(Icons.camera,color: Colors.blue,),
                ),
              ],
            ),
          ),);
      },
    );
  }

  //functions to upload images from the camera or gallery depending on the users choice
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
      padding: const EdgeInsets.all(5),
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

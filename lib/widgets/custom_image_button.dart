import 'package:flutter/material.dart';


//very similar to the custom button but this uses images rather than text
class CustomImageButton extends StatelessWidget {

  final VoidCallback? onPressed;
  final bool? outlined;
  final bool? isLoading;
  final String? image;
  final double? width;

  const CustomImageButton({Key? key, this.onPressed, this.outlined, this.isLoading, this.image, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _outlined = outlined ?? false;
    bool _isLoading = isLoading ?? false;
    //default image in case no image is provided
    String _image = image ?? 'lib/assets/exclamation.png';

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width : width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _outlined ? Colors.transparent : const Color(0xff0e4c76),
          border: Border.all(
            color: _outlined ? Colors.black : const Color(0xff0e4c76),
            width: 1,
          ),
         borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 16,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Visibility(
                visible: _isLoading ? false : true,
                child: Container(
                  width: 50,
                  margin: const EdgeInsets.fromLTRB(3, 10, 3, 10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_image),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ),
            Visibility(
              visible: _isLoading,
              child: Container(
                margin: const EdgeInsets.only(left: 18, right: 18),
                child: const SizedBox(
                  height: 20,
                  width: 20,
                  child:CircularProgressIndicator(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CustomButton extends StatelessWidget {

  final String? text;
  final VoidCallback? onPressed;
  final bool? outlined;
  final bool? isLoading;

  CustomButton({this.text, this.onPressed, this.outlined, this.isLoading});

  @override
  Widget build(BuildContext context) {

    bool _outlined = outlined ?? false;
    bool _isLoading = isLoading ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _outlined ? Colors.transparent : const Color(0xff0e4c76),
          border: Border.all(
            color: _outlined ? Colors.black : const Color(0xff0e4c76),
            width: 1,
          ),
         borderRadius: BorderRadius.circular(30),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Visibility(
              visible: _isLoading ? false : true,
              child: Text(
                text ?? AppLocalizations.of(context)!.defaultTxt,
                style: TextStyle(
                  color: _outlined ? Colors.black : Colors.white,
                ),
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: SizedBox(
                height: 20,
                width: 20,
                child:CircularProgressIndicator(
                  color: Colors.blueGrey,
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}

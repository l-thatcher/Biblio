import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



//custom designed buttons that are used throughout the application for a constant style.
class CustomButton extends StatelessWidget {

  final String? text;
  final VoidCallback? onPressed;
  final bool? outlined;
  final bool? isLoading;
  final double? width;

  const CustomButton({Key? key, this.text, this.onPressed, this.outlined, this.isLoading, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //two different design options are possible
    bool _outlined = outlined ?? false;
    bool _isLoading = isLoading ?? false;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        width : width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _outlined ? Colors.transparent : Theme.of(context).colorScheme.secondary,
          border: Border.all(
            color: _outlined ? Colors.black : Theme.of(context).colorScheme.secondary,
            width: 1,
          ),
         borderRadius: BorderRadius.circular(30),
        ),
        margin: const EdgeInsets.symmetric(
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
              child: const SizedBox(
                height: 20,
                width: 20,
                child:CircularProgressIndicator(
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}

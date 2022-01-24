import 'package:biblio_files/Styles/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//similar to the buttons this is a custom text input which is used through the app
class CustomInput extends StatelessWidget {

  final String? text;
  final bool? primaryInput;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final bool? hiddenText;

  const CustomInput({Key? key, this.text, this.primaryInput, this.onChanged, this.onSubmitted, this.focusNode, this.textInputAction, this.hiddenText}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _primaryInput = primaryInput ?? false;
    bool _hiddenText = hiddenText ?? false;

    
    return Container(
      decoration: BoxDecoration(
        borderRadius: _primaryInput ? BorderRadius.circular(5) : BorderRadius.circular(0),
        color: _primaryInput ? const Color(0xff2C3F576F) : Colors.transparent,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 5,
      ),
      child: TextField(
        obscureText: _hiddenText,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          border: _primaryInput ? InputBorder.none : null,
          hintText: text ?? AppLocalizations.of(context)!.defaultTxt,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
        ),
        style: Constants.regularText,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:goodedunote/common/const/const_text.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const CustomElevatedButton({
    required this.onPressed,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: CONST_TEXT_14,
          ),
          backgroundColor: CONST_COLOR_MAIN,
          foregroundColor: Colors.white,
          padding: EdgeInsets.all(CONST_SIZE_8),
          elevation: 5.0,
          overlayColor: Colors.black),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: CONST_TEXT_FONT,
        ),
      ),
    );
  }
}

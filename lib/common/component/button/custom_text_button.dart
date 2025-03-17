import 'package:flutter/material.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/const/const_size.dart';

class CustomTextButton extends StatelessWidget {
  final TextEditingController? controller;
  final String child;
  final VoidCallback? onPressed;
  final bool? commonStyle;
  final EdgeInsetsGeometry? padding;
  final Alignment? alignment;
  final double? fontSize;
  final double borderSideWidth;

  const CustomTextButton({
    required this.child,
    this.onPressed,
    this.commonStyle = true,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.centerLeft,
    this.fontSize = 14.0,
    this.borderSideWidth = CONST_SIZE_8,
    this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // 기본 텍스트를 controller에 할당
    if(controller!= null && controller!.text.isEmpty){
      controller!.text = child;
    }
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        alignment: alignment,
        padding: padding,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: Colors.black,
        elevation: 5.0,
        side: BorderSide(
          color: CONST_COLOR_WHITE,
          width: borderSideWidth,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            CONST_SIZE_16,
          ),
        ),
        backgroundColor: CONST_COLOR_WHITE,
      ),
      onPressed: onPressed,
      child: Text(
        controller?.text ?? child,
        style:  TextStyle(
          color: const Color(0xff49454f),
          fontSize: fontSize,
        ),
      ),
    );
  }
}

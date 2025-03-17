import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:goodedunote/common/const/const_text.dart';

class CustomTextInputField extends StatelessWidget {
  // TEXT 입력값
  final String? hintText; // 힌트 텍스트
  final String? errorText; // 에러 텍스트
  final FormFieldValidator? validator;

  final bool hideText; //
  final bool autoFocus;
  final double circleBorder; // 테두리 둥글게

  // 옵션 입력
  final bool digitOnly; // 숫자만 입력
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final double? hintSize;
  final double? contentPadding;
  final bool filled;
  final Color borderColor;
  final bool useBorder;
  final int? maxLines;
  final double borderWidth;
  final Color? cursorColor;
  final String? labelText;
  final TextStyle? labelTextStyle;
  final TextStyle? style;
  final TextInputAction? inputAction; // 키보드 확인 버튼 액션
  final ValueChanged<String>? onFieldSubmitted; // 키보드 확인 버튼
  final TextEditingController? controller;

  const CustomTextInputField({
    super.key,
    @required this.onChanged,
    this.hintText,
    this.errorText, // 오류
    this.validator,
    this.hideText = false,
    this.autoFocus = false,
    this.circleBorder = CONST_SIZE_16,
    this.digitOnly = false,
    this.maxLength,
    this.hintSize,
    this.contentPadding,
    this.filled = true,
    this.borderColor = CONST_COLOR_WHITE,
    this.useBorder = true,
    this.maxLines =1,
    this.borderWidth = 1,
    this.cursorColor = CONST_COLOR_MAIN,
    this.labelText,
    this.labelTextStyle,
    this.style,
    this.inputAction,
    this.onFieldSubmitted,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {

    final baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
      borderRadius: BorderRadius.all(Radius.circular(circleBorder))
    );

    final unVisibleBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      )
    );


    return TextFormField(
      controller: controller,
      inputFormatters: [if (digitOnly) FilteringTextInputFormatter.digitsOnly], // 입력 양식
      maxLength: maxLength == null ? null : maxLength, // 입력길이 제한
      maxLines: maxLines,
      cursorColor: cursorColor,
      obscureText: hideText,
      autofocus: autoFocus, // 자동 포커스
      style: style,
      // 이벤트
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      textInputAction: inputAction ?? TextInputAction.newline,
      // 꾸미기
      decoration: InputDecoration(
        counter: const Offstage(),
        contentPadding: contentPadding != null
          ? EdgeInsets.all(contentPadding!)
            : const EdgeInsets.all(CONST_SIZE_20),
        hintText: hintText,
        hintStyle: TextStyle(
          color: CONST_COLOR_MAIN,
          fontSize: hintSize ?? CONST_TEXT_14,
        ),
        errorText: errorText,
        fillColor: CONST_COLOR_WHITE,
        filled: filled, // 배경생 유무
        border: useBorder ? baseBorder : null,
        enabledBorder: useBorder ? baseBorder : unVisibleBorder, // 선택된 상태에서의 볼더

        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: cursorColor,
          ),
        ),
        labelText: labelText,
        labelStyle: labelTextStyle,
      ),

    );
  }
}

import 'package:flutter/material.dart';
import 'package:goodedunote/common/const/const_color.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const CustomCheckbox({
    Key? key,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: value == true ? MaterialStateProperty.all(CONST_COLOR_MAIN) : MaterialStateProperty.all(CONST_COLOR_WHITE), // 체크박스 바탕색
      checkColor: Colors.black,
      side: BorderSide(color: Colors.grey), // 테두리 색상
      onChanged: onChanged, // 상태 변경 콜백
    );
  }
}
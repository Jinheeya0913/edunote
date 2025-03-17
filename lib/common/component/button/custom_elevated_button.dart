import 'package:flutter/material.dart';
import 'package:goodedunote/common/const/const_color.dart';

class CustomElevatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const CustomElevatedButton({
    super.key,
    this.onPressed,
    required this.child,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: CONST_COLOR_MAIN,
      ),
      child: widget.child,
    );
  }
}

import 'package:flutter/material.dart';

class PopupTitle extends StatelessWidget {
  final Widget title;
  final VoidCallback? function;
  final BuildContext context;
  final IconButton? iconButton;

  const PopupTitle({
    required this.title,
    this.function,
    super.key,
    required this.context, this.iconButton,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        title,
        Row(
          children: [
            if(iconButton != null) iconButton!,
            IconButton(
              onPressed: () {
                Navigator.pop(this.context);
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ],
    );
  }
}

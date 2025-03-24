import 'package:flutter/material.dart';

class CustomSimpleAlertPop extends StatefulWidget {
  final String? title;
  final String? content;
  final VoidCallback? onPressed;
  final List<Widget>? actions;

  const CustomSimpleAlertPop({
    this.title,
    this.content,
    this.onPressed,
    this.actions,
    super.key,
  });

  @override
  State<CustomSimpleAlertPop> createState() => _CustomSimpleAlertPopState();
}

class _CustomSimpleAlertPopState extends State<CustomSimpleAlertPop> {
  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: widget.title != null ? Text(widget.title!) : null,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.content != null) Text(widget.content!),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment:
                widget.actions != null || widget.onPressed != null
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.end,
            children: widget.actions != null
                ? widget.actions!
                : [
                    if (widget.onPressed != null)
                      ElevatedButton(
                          onPressed: widget.onPressed, child: const Text('확인')),
                    if(widget.onPressed == null)
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('돌아가기'),
                    ),
                  ],
          )
        ]);
  }
}

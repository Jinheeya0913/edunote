import 'package:flutter/material.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/const/const_size.dart';

class CustomSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onChanged;
  final VoidCallback? onSubmitted;
  final VoidCallback? onTapOutside;
  final TextEditingController? gubunController;
  final Widget? leading;
  final Iterable<Widget>? tailing;
  final WidgetStateProperty? side;
  final WidgetStateProperty? shape;

  const CustomSearchBar({
    super.key,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onTapOutside,
    this.gubunController,
    this.leading,
    this.tailing,
    this.side,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      leading: leading,
      trailing: tailing,
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(
          horizontal: CONST_SIZE_20,
          vertical: CONST_SIZE_8,
        ),
      ),
      controller: gubunController,
      hintText: '검색어를 입력하세요',
      backgroundColor: WidgetStateProperty.all(CONST_COLOR_WHITE),
      side: side ?? _renderSide(),
      shape: shape ??  _renderShape(),
    );
  }

  _renderSide(){
    return WidgetStateProperty.all(const BorderSide(
      color: CONST_COLOR_MAIN,
      width: 4.0,
    ));
  }

  _renderShape(){
    return WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          CONST_SIZE_16,
        ),
      ),
    );
  }
}

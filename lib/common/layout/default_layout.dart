import 'package:flutter/material.dart';
import 'package:goodedunote/common/component/user_drawer.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:go_router/go_router.dart';


class DefaultLayout extends StatefulWidget {
  final Widget child;
  final Widget? title;
  final Widget? bottomNavigationBar;
  final bool? useDrawer;
  final bool? useAppBar;
  final bool? useBackBtn;

  const DefaultLayout({
    super.key,
    required this.child,
    this.title,
    this.bottomNavigationBar,
    this.useDrawer = false,
    this.useBackBtn = false,
    this.useAppBar = true,
  });

  @override
  State<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        drawer: widget.useDrawer==true ? renderDrawer() : null,
        appBar: renderAppBar(),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            // height: MediaQuery.of(context).size.height -40,
            padding: const EdgeInsets.symmetric(
                vertical: CONST_SIZE_16, horizontal: CONST_SIZE_16),
            child: widget.child,
          ),
        ),
        bottomNavigationBar: widget.bottomNavigationBar,
      ),
    );
  }

  AppBar? renderAppBar() {
    if (widget.useAppBar!) {
      return AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Badge(
              isLabelVisible: true,
              label: Text('2'),
              backgroundColor: CONST_COLOR_MAIN,
              child: Icon(Icons.notifications),

            ),
          )
        ],
        title: widget.title,
        leading: Row(
          children: [
            if (widget.useBackBtn == true)
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () {
                    GoRouter.of(context).pop();
                  },
                ),
              ),
            if (widget.useDrawer == true)
              Expanded(
                child: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
              ),
          ],
        ),
      );
    } else {

      return null;
    }
  }

  UserDrawer renderDrawer (){
    return UserDrawer();
  }
}

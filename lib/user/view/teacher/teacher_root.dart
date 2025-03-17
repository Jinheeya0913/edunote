import 'package:flutter/material.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/layout/default_layout.dart';
import 'package:goodedunote/user/view/user_home_screen.dart';
import 'package:goodedunote/user/view/user_myPage_screen.dart';

class TeacherRootScreen extends StatefulWidget {
  static String get routeName => 'teacherMain';

  const TeacherRootScreen({super.key});

  @override
  State<TeacherRootScreen> createState() => _TeacherRootScreenState();
}

class _TeacherRootScreenState extends State<TeacherRootScreen>
    with SingleTickerProviderStateMixin {
  int index = 0;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(tabListener);
  }

  @override
  void dispose() {
    tabController.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: Text('TEACHER'),
      useDrawer: true,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: CONST_COLOR_TEACHER,
        unselectedItemColor: CONST_COLOR_NOTUSED,
        onTap: (int index) {
          tabController.animateTo(index);
        },
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '캘린더',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '마이에듀',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
      ),
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          Center(
            child: UserHomeScreen(),
          ),
          Center(
            child: Text('달력'),
          ),
          Center(
            child: Text('마이에듀'),
          ),
          Center(
            child: UserMyPageScreen(),
          ),
        ],
      ),
    );
  }
}

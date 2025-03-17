import 'package:flutter/material.dart';
import 'package:goodedunote/common/layout/default_layout.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child: Column(children: [],),);
  }
}

import 'package:flutter/material.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:goodedunote/common/layout/default_layout.dart';
import 'package:goodedunote/user/model/user_model.dart';
import 'package:goodedunote/user/view/student/student_root.dart';
import 'package:goodedunote/user/view/user_login_screen.dart';

import 'common/const/const_data.dart';

class SplashScreen extends StatefulWidget {
  static String get routeName => 'splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note_sharp,
              size: 140.0,
            ),
            SizedBox(
              height: CONST_SIZE_16,
            ),
            CircularProgressIndicator(
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}

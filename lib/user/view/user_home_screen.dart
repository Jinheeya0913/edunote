import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodedunote/user/component/student_myedu_card.dart';
import 'package:goodedunote/user/component/teacher_myedu_card.dart';
import 'package:goodedunote/user/func/user_func.dart';
import 'package:go_router/go_router.dart';
import 'package:goodedunote/user/model/student_model.dart';
import 'package:goodedunote/user/model/teahcer_model.dart';
import 'package:goodedunote/user/model/user_model.dart';
import 'package:goodedunote/user/provider/user_provider.dart';
import 'package:goodedunote/user/view/user_login_screen.dart';

class UserHomeScreen extends ConsumerStatefulWidget {
  const UserHomeScreen({super.key});

  @override
  ConsumerState<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends ConsumerState<UserHomeScreen> {

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProvider);
    UserModel? user;
    if(state == null){
      context.goNamed(LoginScreen.routeName);
    }

    if(state is StudentModel){
      user = state as StudentModel;
    } else if (state is TeacherModel) {
      user = state as TeacherModel;
    }


    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if(user!=null) renderMyCard(user),
          // 학생 카드
        ],
      ),
    );
  }

  // 최상단 유저카드 그리기
  Widget renderMyCard(UserModel userModel){
    var myCard;

    if(userModel is StudentModel) myCard =  StudentMyEduCard();
    if(userModel is TeacherModel) myCard = TeacherMyEduCard();

    return myCard;
  }


  



}

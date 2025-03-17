import 'package:flutter/material.dart';
import 'package:goodedunote/common/component/custom_elevated_button.dart';
import 'package:goodedunote/common/component/popup/PopupTitle.dart';
import 'package:go_router/go_router.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:goodedunote/user/model/student_model.dart';
import 'package:goodedunote/user/view/teacher/teacher_lecture_create_screen.dart';

class StudentSimpleInfoPop extends StatefulWidget {
  final StudentModel studentModel;
  final bool isConnected;

  const StudentSimpleInfoPop({
    required this.studentModel,
    required this.isConnected,
    super.key,
  });

  @override
  State<StudentSimpleInfoPop> createState() => _StudentSimpleInfoPopState();
}

class _StudentSimpleInfoPopState extends State<StudentSimpleInfoPop> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: PopupTitle(title: Text('학생 정보'), context: context),
      content: Card(
        surfaceTintColor: Colors.white60,
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: CONST_SIZE_20, horizontal: CONST_SIZE_16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: const CircleAvatar(
                  radius: 40.0,
                  backgroundImage: NetworkImage(
                      "https://firebasestorage.googleapis.com/v0/b/edunote-9883e.appspot.com/o/user%2FprofileImg%2FKakaoTalk_20241017_165047382.png?alt=media&token=3a4924f0-2afc-4ce1-a2b3-6391a9ea6b26"),
                ),
              ),
              const SizedBox(height: CONST_SIZE_8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('이름'),
                          Text('닉네임'),
                          Text('전화번호'),
                          Text('학교'),
                          // Todo 사는 곳 추가
                        ],
                      ),
                      const SizedBox(width: CONST_SIZE_20),
                      Column(
                        children: [
                          Text(widget.studentModel.userNm),
                          Text(widget.studentModel.userAlias),
                          Text(widget.studentModel.userPhone),
                          Text(widget.studentModel.schoolNm),
                          // Text(maskEmail(widget.studentModel.userEmail)),
                        ],
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: CONST_SIZE_20),
              if (widget.isConnected)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: () {},
                        text: '학습관리',
                      ),
                    ),
                    SizedBox(width: CONST_SIZE_8),
                    Expanded(
                      child:
                          CustomElevatedButton(onPressed: () {
                            context.goNamed(TeacherLectureCreateScreen.routeName);
                          }, text: '학습등록'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

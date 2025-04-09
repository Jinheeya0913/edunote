import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:goodedunote/common/component/custom_elevated_button.dart';
import 'package:goodedunote/common/component/popup/PopupTitle.dart';
import 'package:goodedunote/common/component/user_drawer.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:goodedunote/common/func/popupFunc.dart';
import 'package:goodedunote/edu/view/lecture_search_screen.dart';
import 'package:goodedunote/user/func/user_func.dart';
import 'package:goodedunote/user/model/teahcer_model.dart';

class TeacherSimpleInfoPop extends StatefulWidget {
  final TeacherModel teacherModel;
  final bool isConnected;

  const TeacherSimpleInfoPop({
    required this.teacherModel,
    required this.isConnected,
    super.key,
  });

  @override
  State<TeacherSimpleInfoPop> createState() => _TeacherSimpleInfoPopState();
}

class _TeacherSimpleInfoPopState extends State<TeacherSimpleInfoPop> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: PopupTitle(title: Text('쌤 정보'), context: context),
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
                          // Todo 사는 곳 추가
                        ],
                      ),
                      const SizedBox(width: CONST_SIZE_20),
                      Column(
                        children: [
                          Text(widget.teacherModel.userNm),
                          Text(widget.teacherModel.userAlias),
                          TextButton(
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              foregroundColor: Colors.black,
                              elevation: 5.0,
                            ),
                            onPressed: () async {
                              if (widget.isConnected) {
                                await Clipboard.setData(ClipboardData(
                                    text: widget.teacherModel.userPhone));
                                showOverlayNotification(
                                    context, '전화번호가 복사되었습니다');
                              }
                            },
                            child: Text(
                              widget.isConnected
                                  ? widget.teacherModel.userPhone
                                  : maskPhoneNumber(
                                      widget.teacherModel.userPhone),
                            ),
                          ),
                          // Text(widget.teacherModel.userPhone),
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
                      child: CustomElevatedButton(
                          onPressed: () {
                            context.goNamed(
                              LectureSearchScreen.routeName,
                              extra: widget.teacherModel,
                            );
                          },
                          text: '강의목록'),
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

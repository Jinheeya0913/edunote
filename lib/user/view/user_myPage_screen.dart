import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:goodedunote/common/const/const_text.dart';
import 'package:goodedunote/user/component/user_profile_circle.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:goodedunote/user/model/student_model.dart';
import 'package:goodedunote/user/model/teahcer_model.dart';
import 'package:goodedunote/user/provider/user_provider.dart';
import 'package:goodedunote/user/view/student/student_teacher_list_pop.dart';
import 'package:goodedunote/user/view/teacher/teacher_lecture_create_screen.dart';
import 'package:goodedunote/user/view/teacher/teacher_lecture_list_screen.dart';
import 'package:goodedunote/user/view/teacher/teacher_linked_students_screen.dart';
import 'package:goodedunote/user/view/teacher/teacher_student_list_pop.dart';
import 'package:go_router/go_router.dart';

class UserMyPageScreen extends ConsumerStatefulWidget {
  const UserMyPageScreen({super.key});

  @override
  ConsumerState<UserMyPageScreen> createState() => _UserMyPageScreenState();
}

class _UserMyPageScreenState extends ConsumerState<UserMyPageScreen> {
  @override
  Widget build(BuildContext context) {
    var userModel = ref.watch(userProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // renderMyCard(userModel),
          if (userModel is TeacherModel) buildTeacherCard(context, userModel),
          if (userModel is StudentModel) buildStudentCard(context, userModel),
          const SizedBox(height: CONST_SIZE_40),
          const Row(
            children: [
              Text(
                '제목',
                style : TextStyle(
                  fontSize: CONST_TEXT_20
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Card buildTeacherCard(BuildContext context, TeacherModel userModel) {
    return Card(
          color: Color.fromRGBO(107, 171, 255, 0.9),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: CONST_SIZE_16, vertical: CONST_SIZE_8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userModel.userNm,
                            style: const TextStyle(
                              fontSize: CONST_TEXT_20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: CONST_SIZE_8),
                          Text(
                            userModel.userAlias,
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_horiz,
                        ),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: CONST_SIZE_8),
                  const DottedLine(
                    direction: Axis.horizontal,
                    dashColor: Colors.white,
                  ),
                  SizedBox(height: CONST_SIZE_8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                UserProfileCircle(),
                              ],
                            ),
                            SizedBox(
                              width: CONST_SIZE_20,
                            ),
                            Column(
                              children: [
                                Text(
                                  '학 생 Q&A',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '학부모 Q&A',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '학부모 Q&A',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: CONST_SIZE_16,
                            ),
                            Column(
                              children: [
                                Text(
                                  '1 건',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '1 건',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '3 건',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: CONST_SIZE_8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            // 팝업 이동 방식
                            // await showGeneralDialog(
                            //   barrierDismissible: true,
                            //   barrierLabel: 'Dismiss',
                            //   context: context,
                            //   pageBuilder: (BuildContext context,
                            //       Animation<double> animation,
                            //       Animation<double> secondaryAnimation) {
                            //     return ScaleTransition(
                            //       scale: Tween<double>(begin: 0.5, end: 1.0)
                            //           .animate(animation),
                            //       child: StudentListPopUp(),
                            //     );
                            //   },
                            // );

                            // 페이지 이동으로 변경
                            context.goNamed(TeacherLinkedStudentScreen.routeName);

                          },
                          child: const Text(
                            '학생관리',
                            style: TextStyle(
                              fontSize: CONST_TEXT_10,
                              color: CONST_COLOR_STUDENT,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: CONST_SIZE_8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.goNamed(TeacherLectureListScreen.routeName);
                          },
                          child: const Text(
                            '강의목록',
                            style: TextStyle(
                              fontSize: CONST_TEXT_10,
                              color: CONST_COLOR_STUDENT,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: CONST_SIZE_8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context.goNamed(TeacherLectureCreateScreen.routeName);
                          },
                          child: const Text(
                            '강의등록',
                            style: TextStyle(
                              fontSize: CONST_TEXT_10,
                              color: CONST_COLOR_STUDENT,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
  }

  Card buildStudentCard(BuildContext context, StudentModel userModel){
    return Card(
      color: Color.fromRGBO(107, 171, 255, 0.9),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: CONST_SIZE_16, vertical: CONST_SIZE_8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        userModel.userNm,
                        style: const TextStyle(
                          fontSize: CONST_TEXT_20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: CONST_SIZE_8),
                      Text(
                        userModel.userAlias,
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz,
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: CONST_SIZE_8),
              const DottedLine(
                direction: Axis.horizontal,
                dashColor: Colors.white,
              ),
              SizedBox(height: CONST_SIZE_8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            UserProfileCircle(),
                          ],
                        ),
                        SizedBox(
                          width: CONST_SIZE_20,
                        ),
                        Column(
                          children: [
                            Text(
                              '다음수업',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '수업종료',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '남은과제',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: CONST_SIZE_16,
                        ),
                        Column(
                          children: [
                            Text(
                              '2024/01/02',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '2024/12/30',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '3 건',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: CONST_SIZE_8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await showGeneralDialog(
                          barrierDismissible: true,
                          barrierLabel: 'Dismiss',
                          context: context,
                          pageBuilder: (BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation) {
                            return ScaleTransition(
                              scale: Tween<double>(begin: 0.5, end: 1.0)
                                  .animate(animation),
                              child: TeacherListPopUp(),
                            );
                          },
                        );
                      },
                      child: const Text(
                        '마이티처',
                        style: TextStyle(
                          fontSize: CONST_TEXT_10,
                          color: CONST_COLOR_STUDENT,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: CONST_SIZE_8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        '2',
                        style: TextStyle(
                          fontSize: CONST_TEXT_10,
                          color: CONST_COLOR_STUDENT,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: CONST_SIZE_8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                        '3',
                        style: TextStyle(
                          fontSize: CONST_TEXT_10,
                          color: CONST_COLOR_STUDENT,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}

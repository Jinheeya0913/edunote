import 'package:flutter/material.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:goodedunote/common/const/const_text.dart';
import 'package:goodedunote/user/component/user_profile_circle.dart';
import 'package:goodedunote/user/model/student_model.dart';
import 'package:goodedunote/user/provider/user_provider.dart';
import 'package:goodedunote/user/view/student/student_teacher_list_pop.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentInfoCard extends ConsumerStatefulWidget {


  const StudentInfoCard({
    super.key,

  });

  @override
  ConsumerState<StudentInfoCard> createState() => _StudentInfoCardState();
}

class _StudentInfoCardState extends ConsumerState<StudentInfoCard> {
  @override
  Widget build(BuildContext context) {
    final studentModel = ref.watch(userProvider) as StudentModel;
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
                        studentModel.userNm,
                        style: const TextStyle(
                          fontSize: CONST_TEXT_20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: CONST_SIZE_8),
                      Text(
                        studentModel.userAlias,
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
              const SizedBox(height: CONST_SIZE_8),
              const DottedLine(
                direction: Axis.horizontal,
                dashColor: Colors.white,
              ),
              const SizedBox(height: CONST_SIZE_8),
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

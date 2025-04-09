import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:goodedunote/common/layout/default_layout.dart';
import 'package:goodedunote/edu/model/lecture_model.dart';

class TeacherLectureApplyScreen extends ConsumerStatefulWidget {
  static String get routeName => 'teacherLectureApplyList';

  final LectureModel lectureModel;

  const TeacherLectureApplyScreen({
    required this.lectureModel,
    super.key,
  });

  @override
  ConsumerState<TeacherLectureApplyScreen> createState() =>
      _TeacherLectureApplyScreenState();
}

class _TeacherLectureApplyScreenState
    extends ConsumerState<TeacherLectureApplyScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      useDrawer: true,
      useBackBtn: true,
      child: Center(
        child: Text('center'),
      ),
    );
  }
}

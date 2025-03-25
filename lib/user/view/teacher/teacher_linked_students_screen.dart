import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goodedunote/common/layout/default_layout.dart';

class TeacherLinkedStudentScreen extends ConsumerStatefulWidget {
  static String get routeName => 'linkedStudentList';

  const TeacherLinkedStudentScreen({super.key});

  @override
  ConsumerState<TeacherLinkedStudentScreen> createState() =>
      _TeacherLinkedStudentsScreenState();
}

class _TeacherLinkedStudentsScreenState
    extends ConsumerState<TeacherLinkedStudentScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: Text('학생목록'),
      child: Center(
        child: Text('data'),
      ),
    );
  }
}

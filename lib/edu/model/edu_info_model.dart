import 'package:goodedunote/user/enum/user_enum.dart';

class EduInfoModel {
  final String studentId;
  final String teacherId;
  final LINKED_STATUS linked_status;


  EduInfoModel({
    required this.studentId,
    required this.teacherId,
    required this.linked_status,
  });
}

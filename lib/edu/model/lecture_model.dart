import 'package:goodedunote/common/func/firestore_func.dart';
import 'package:goodedunote/edu/enum/edu_enum.dart';
import 'package:goodedunote/user/enum/user_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lecture_model.g.dart';

@JsonSerializable()
class LectureModel {
  final String? lectureId;
  final String teacherId;
  final String lectureNm;
  final String lectureEtc;
  final int lectureLikes;
  final int totalStudents;
  final double lectureRating;
  final String? curriculum;
  final String lectureCount;
  final String lectureSubject;
  final String? subjectOpt;
  final STUDENT_GUBUN targetParticipant;
  final LECTURE_PAY_ENUM lecturePayGubun;
  final List <LECTURE_DAY>? lectureDayList;
  final String? lectureCost;
  final int? maxParticipants;
  final int nowParticipants;
  final DateTime createDt;
  final DateTime? deadLineDt;
  final DateTime? modifyDt;

  LectureModel({
    this.lectureId,
    required this.teacherId,
    required this.lectureNm,
    required this.lectureEtc,
    required this.lectureLikes,
    required this.totalStudents,
    required this.lectureRating,
    required this.lectureSubject,
    required this.curriculum,
    required this.lectureCount,
    required this.targetParticipant,
    required this.nowParticipants,
    required this.lecturePayGubun,
    this.lectureDayList,
    this.lectureCost,
    this.maxParticipants,
    required this.createDt,
    this.subjectOpt,
    this.deadLineDt,
    this.modifyDt,
  });
  
  factory LectureModel.fromJson(Map<String, dynamic> json) =>
        _$LectureModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$LectureModelToJson(this)
  ..update('createDt', (val)=> formatDateToTimestamp(createDt))
  ..update('deadLineDt', (val)=> formatDateToTimestamp(deadLineDt))
  ..update('modifyDt', (val)=> formatDateToTimestamp(modifyDt));

}

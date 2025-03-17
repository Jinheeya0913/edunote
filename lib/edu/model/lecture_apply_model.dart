import 'package:goodedunote/edu/enum/edu_enum.dart';
import 'package:goodedunote/edu/model/lecture_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lecture_apply_model.g.dart';

@JsonSerializable()
class LectureApplyModel {
  final String lectureId;
  final List<LECTURE_DAY> lectureDayList;
  final bool? timeAleady;
  final DateTime? startTime;
  final DateTime? endTime;
  final LECTURE_LEVEL lectureLevel;
  final String? lectureRecommend;

  LectureApplyModel({
    required this.lectureId,
    required this.lectureDayList,
    this.timeAleady,
    this.startTime,
    this.endTime,
    required this.lectureLevel,
    this.lectureRecommend,
  });


  Map<String, dynamic> toJson() => _$LectureApplyModelToJson(this);

  factory LectureApplyModel.fromJson(Map<String, dynamic> json) =>
        _$LectureApplyModelFromJson(json);
}

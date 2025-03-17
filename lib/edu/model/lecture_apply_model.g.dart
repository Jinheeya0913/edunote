// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecture_apply_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LectureApplyModel _$LectureApplyModelFromJson(Map<String, dynamic> json) =>
    LectureApplyModel(
      lectureId: json['lectureId'] as String,
      lectureDayList: (json['lectureDayList'] as List<dynamic>)
          .map((e) => $enumDecode(_$LECTURE_DAYEnumMap, e))
          .toList(),
      timeAleady: json['timeAleady'] as bool?,
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      lectureLevel: $enumDecode(_$LECTURE_LEVELEnumMap, json['lectureLevel']),
      lectureRecommend: json['lectureRecommend'] as String?,
    );

Map<String, dynamic> _$LectureApplyModelToJson(LectureApplyModel instance) =>
    <String, dynamic>{
      'lectureId': instance.lectureId,
      'lectureDayList':
          instance.lectureDayList.map((e) => _$LECTURE_DAYEnumMap[e]!).toList(),
      'timeAleady': instance.timeAleady,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'lectureLevel': _$LECTURE_LEVELEnumMap[instance.lectureLevel]!,
      'lectureRecommend': instance.lectureRecommend,
    };

const _$LECTURE_DAYEnumMap = {
  LECTURE_DAY.MON: 'MON',
  LECTURE_DAY.TUE: 'TUE',
  LECTURE_DAY.THU: 'THU',
  LECTURE_DAY.WED: 'WED',
  LECTURE_DAY.FRI: 'FRI',
  LECTURE_DAY.SAT: 'SAT',
  LECTURE_DAY.SUN: 'SUN',
  LECTURE_DAY.ALL: 'ALL',
};

const _$LECTURE_LEVELEnumMap = {
  LECTURE_LEVEL.HIGH: 'HIGH',
  LECTURE_LEVEL.MIDDLE: 'MIDDLE',
  LECTURE_LEVEL.LOW: 'LOW',
};

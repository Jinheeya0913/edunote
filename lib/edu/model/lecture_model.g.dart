// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecture_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LectureModel _$LectureModelFromJson(Map<String, dynamic> json) => LectureModel(
      lectureId: json['lectureId'] as String?,
      teacherId: json['teacherId'] as String,
      lectureNm: json['lectureNm'] as String,
      lectureEtc: json['lectureEtc'] as String,
      lectureLikes: (json['lectureLikes'] as num).toInt(),
      totalStudents: (json['totalStudents'] as num).toInt(),
      lectureRating: (json['lectureRating'] as num).toDouble(),
      lectureSubject: json['lectureSubject'] as String,
      curriculum: json['curriculum'] as String?,
      lectureCount: json['lectureCount'] as String,
      targetParticipant:
          $enumDecode(_$STUDENT_GUBUNEnumMap, json['targetParticipant']),
      nowParticipants: (json['nowParticipants'] as num).toInt(),
      lecturePayGubun:
          $enumDecode(_$LECTURE_PAY_ENUMEnumMap, json['lecturePayGubun']),
      lectureDayList: (json['lectureDayList'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$LECTURE_DAYEnumMap, e))
          .toList(),
      lectureCost: json['lectureCost'] as String?,
      maxParticipants: (json['maxParticipants'] as num?)?.toInt(),
      createDt: DateTime.parse(json['createDt'] as String),
      subjectOpt: json['subjectOpt'] as String?,
      deadLineDt: json['deadLineDt'] == null
          ? null
          : DateTime.parse(json['deadLineDt'] as String),
      modifyDt: json['modifyDt'] == null
          ? null
          : DateTime.parse(json['modifyDt'] as String),
    );

Map<String, dynamic> _$LectureModelToJson(LectureModel instance) =>
    <String, dynamic>{
      'lectureId': instance.lectureId,
      'teacherId': instance.teacherId,
      'lectureNm': instance.lectureNm,
      'lectureEtc': instance.lectureEtc,
      'lectureLikes': instance.lectureLikes,
      'totalStudents': instance.totalStudents,
      'lectureRating': instance.lectureRating,
      'curriculum': instance.curriculum,
      'lectureCount': instance.lectureCount,
      'lectureSubject': instance.lectureSubject,
      'subjectOpt': instance.subjectOpt,
      'targetParticipant': _$STUDENT_GUBUNEnumMap[instance.targetParticipant]!,
      'lecturePayGubun': _$LECTURE_PAY_ENUMEnumMap[instance.lecturePayGubun]!,
      'lectureDayList': instance.lectureDayList
          ?.map((e) => _$LECTURE_DAYEnumMap[e]!)
          .toList(),
      'lectureCost': instance.lectureCost,
      'maxParticipants': instance.maxParticipants,
      'nowParticipants': instance.nowParticipants,
      'createDt': instance.createDt.toIso8601String(),
      'deadLineDt': instance.deadLineDt?.toIso8601String(),
      'modifyDt': instance.modifyDt?.toIso8601String(),
    };

const _$STUDENT_GUBUNEnumMap = {
  STUDENT_GUBUN.element: 'element',
  STUDENT_GUBUN.middle: 'middle',
  STUDENT_GUBUN.high: 'high',
  STUDENT_GUBUN.all: 'all',
};

const _$LECTURE_PAY_ENUMEnumMap = {
  LECTURE_PAY_ENUM.MONTH: 'MONTH',
  LECTURE_PAY_ENUM.COUNT: 'COUNT',
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

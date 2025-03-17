// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentModel _$StudentModelFromJson(Map<String, dynamic> json) => StudentModel(
      userEmail: json['userEmail'] as String,
      userId: json['userId'] as String,
      userNm: json['userNm'] as String,
      userAlias: json['userAlias'] as String,
      userPhone: json['userPhone'] as String,
      user_gubun: $enumDecode(_$USER_GUBUNEnumMap, json['user_gubun']),
      schoolNm: json['schoolNm'] as String,
      connectInfo: (json['connectInfo'] as List<dynamic>?)
          ?.map((e) => ConnectModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      userImgUrl: json['userImgUrl'] as String?,
      userPw: json['userPw'] as String?,
    );

Map<String, dynamic> _$StudentModelToJson(StudentModel instance) =>
    <String, dynamic>{
      'userEmail': instance.userEmail,
      'userId': instance.userId,
      'userNm': instance.userNm,
      'userAlias': instance.userAlias,
      'userPhone': instance.userPhone,
      'user_gubun': _$USER_GUBUNEnumMap[instance.user_gubun]!,
      'connectInfo': instance.connectInfo,
      'userPw': instance.userPw,
      'userImgUrl': instance.userImgUrl,
      'schoolNm': instance.schoolNm,
    };

const _$USER_GUBUNEnumMap = {
  USER_GUBUN.student: 'student',
  USER_GUBUN.parent: 'parent',
  USER_GUBUN.teacher: 'teacher',
};

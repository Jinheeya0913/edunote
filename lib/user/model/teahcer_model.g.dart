// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teahcer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherModel _$TeacherModelFromJson(Map<String, dynamic> json) => TeacherModel(
      userEmail: json['userEmail'] as String,
      userId: json['userId'] as String,
      userNm: json['userNm'] as String,
      userPhone: json['userPhone'] as String,
      userAlias: json['userAlias'] as String,
      user_gubun: $enumDecode(_$USER_GUBUNEnumMap, json['user_gubun']),
      connectInfo: (json['connectInfo'] as List<dynamic>?)
          ?.map((e) => ConnectModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      userPw: json['userPw'] as String?,
      userImgUrl: json['userImgUrl'] as String?,
      academyName: json['academyName'] as String?,
      academyPresident: json['academyPresident'] as String?,
      academyAddress: json['academyAddress'] as String?,
      academyTelNumber: json['academyTelNumber'] as String?,
    );

Map<String, dynamic> _$TeacherModelToJson(TeacherModel instance) =>
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
      'academyName': instance.academyName,
      'academyPresident': instance.academyPresident,
      'academyAddress': instance.academyAddress,
      'academyTelNumber': instance.academyTelNumber,
    };

const _$USER_GUBUNEnumMap = {
  USER_GUBUN.student: 'student',
  USER_GUBUN.parent: 'parent',
  USER_GUBUN.teacher: 'teacher',
};

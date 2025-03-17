// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userEmail: json['userEmail'] as String,
      userId: json['userId'] as String,
      userNm: json['userNm'] as String,
      userAlias: json['userAlias'] as String,
      userPw: json['userPw'] as String?,
      userPhone: json['userPhone'] as String,
      userImgUrl: json['userImgUrl'] as String?,
      connectInfo: (json['connectInfo'] as List<dynamic>?)
          ?.map((e) => ConnectModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      user_gubun: $enumDecode(_$USER_GUBUNEnumMap, json['user_gubun']),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'userEmail': instance.userEmail,
      'userId': instance.userId,
      'userNm': instance.userNm,
      'userAlias': instance.userAlias,
      'userPhone': instance.userPhone,
      'user_gubun': _$USER_GUBUNEnumMap[instance.user_gubun]!,
      'connectInfo': instance.connectInfo,
      'userPw': instance.userPw,
      'userImgUrl': instance.userImgUrl,
    };

const _$USER_GUBUNEnumMap = {
  USER_GUBUN.student: 'student',
  USER_GUBUN.parent: 'parent',
  USER_GUBUN.teacher: 'teacher',
};

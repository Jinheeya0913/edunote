// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connect_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectModel _$ConnectModelFromJson(Map<String, dynamic> json) => ConnectModel(
      connectId: json['connectId'] as String,
      studentId: json['studentId'] as String,
      teacherId: json['teacherId'] as String,
      linked_status: $enumDecode(_$LINKED_STATUSEnumMap, json['linked_status']),
      createDt: json['createDt'] as String,
      memo: json['memo'] as String?,
      modifyDt: json['modifyDt'] as String?,
    );

Map<String, dynamic> _$ConnectModelToJson(ConnectModel instance) =>
    <String, dynamic>{
      'connectId': instance.connectId,
      'studentId': instance.studentId,
      'teacherId': instance.teacherId,
      'linked_status': _$LINKED_STATUSEnumMap[instance.linked_status]!,
      'createDt': instance.createDt,
      'modifyDt': instance.modifyDt,
      'memo': instance.memo,
    };

const _$LINKED_STATUSEnumMap = {
  LINKED_STATUS.linked: 'linked',
  LINKED_STATUS.wait: 'wait',
  LINKED_STATUS.refused: 'refused',
  LINKED_STATUS.canceled: 'canceled',
};

ConnectRequestModel _$ConnectRequestModelFromJson(Map<String, dynamic> json) =>
    ConnectRequestModel(
      studentInfo: json['studentInfo'] as Map<String, dynamic>?,
      teacherInfo: json['teacherInfo'] as Map<String, dynamic>?,
      studentId: json['studentId'] as String,
      teacherId: json['teacherId'] as String,
      linked_status: $enumDecode(_$LINKED_STATUSEnumMap, json['linked_status']),
      createDt: json['createDt'] as String,
      modifyDt: json['modifyDt'] as String?,
    );

Map<String, dynamic> _$ConnectRequestModelToJson(
        ConnectRequestModel instance) =>
    <String, dynamic>{
      'studentInfo': instance.studentInfo,
      'teacherInfo': instance.teacherInfo,
      'studentId': instance.studentId,
      'teacherId': instance.teacherId,
      'createDt': instance.createDt,
      'modifyDt': instance.modifyDt,
      'linked_status': _$LINKED_STATUSEnumMap[instance.linked_status]!,
    };

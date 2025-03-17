import 'package:goodedunote/user/enum/user_enum.dart';
import 'package:json_annotation/json_annotation.dart';

part 'connect_model.g.dart';

@JsonSerializable()
class ConnectModel {
  final String connectId;
  final String studentId;
  final String teacherId;
  final LINKED_STATUS linked_status;
  final String createDt;
  final String? modifyDt;
  String? memo;

  ConnectModel(
      {required this.connectId,
      required this.studentId,
      required this.teacherId,
      required this.linked_status,
      required this.createDt,
      this.memo,
      this.modifyDt});

  factory ConnectModel.fromJson(Map<String, dynamic> json) =>
      _$ConnectModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectModelToJson(this);
}

@JsonSerializable()
class ConnectRequestModel {
  final Map<String, dynamic>? studentInfo;
  final Map<String, dynamic>? teacherInfo;
  final String studentId;
  final String teacherId;
  final String createDt;
  final String? modifyDt;
  final LINKED_STATUS linked_status;

  ConnectRequestModel({
    this.studentInfo,
    this.teacherInfo,
    required this.studentId,
    required this.teacherId,
    required this.linked_status,
    required this.createDt,
    this.modifyDt,
  });

  Map<String, dynamic> toJson() => _$ConnectRequestModelToJson(this);

  factory ConnectRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ConnectRequestModelFromJson(json);
}

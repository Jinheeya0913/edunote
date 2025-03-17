import 'package:goodedunote/user/model/user_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'connect_model.dart';
import 'package:goodedunote/user/enum/user_enum.dart';


part 'student_model.g.dart';


@JsonSerializable()
class StudentModel extends UserModel {

  final String schoolNm;

  StudentModel({
    required super.userEmail,
    required super.userId,
    required super.userNm,
    required super.userAlias,
    required super.userPhone,
    required super.user_gubun,
    required this.schoolNm,
    super.connectInfo,
    super.userImgUrl,
    super.userPw,
  });
  
  factory StudentModel.fromJson(Map<String, dynamic> json) =>
        _$StudentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentModelToJson(this);
}

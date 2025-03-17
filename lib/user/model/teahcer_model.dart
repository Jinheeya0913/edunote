import 'package:goodedunote/user/enum/user_enum.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:goodedunote/user/model/user_model.dart';
import 'connect_model.dart';


part 'teahcer_model.g.dart';

@JsonSerializable()
class TeacherModel extends UserModel {
   String? academyName;
   String? academyPresident;
   String? academyAddress;
   String? academyTelNumber;

  TeacherModel({
    required super.userEmail,
    required super.userId,
    required super.userNm,
    required super.userPhone,
    required super.userAlias,
    required super.user_gubun,
    super.connectInfo,
    super.userPw,
    super.userImgUrl,
    this.academyName,
    this.academyPresident,
    this.academyAddress,
    this.academyTelNumber,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) =>
        _$TeacherModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$TeacherModelToJson(this);




}

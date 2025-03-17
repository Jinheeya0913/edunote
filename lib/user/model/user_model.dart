import 'package:goodedunote/user/enum/user_enum.dart';
import 'package:goodedunote/user/model/connect_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

abstract class UserBaseModel {}

class UserErrorModel extends UserBaseModel {
  final String message;

  UserErrorModel({
    required this.message,
  });
}

class UserLoadingModel extends UserBaseModel {
  UserLoadingModel();
}

@JsonSerializable()
class UserModel extends UserBaseModel {
  final String userEmail;
  final String userId;
  final String userNm;
  String userAlias;
  String userPhone;
  final USER_GUBUN user_gubun;
  List<ConnectModel>? connectInfo;

  String? userPw;
  String? userImgUrl;

  UserModel({
    required this.userEmail,
    required this.userId,
    required this.userNm,
    required this.userAlias,
    this.userPw,
    required this.userPhone,
    this.userImgUrl,
    this.connectInfo,
    required this.user_gubun,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

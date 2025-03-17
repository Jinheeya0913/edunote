

import 'dart:convert';

import 'package:flutter/src/material/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/const/const_data.dart';
import 'package:goodedunote/user/component/student_myedu_card.dart';
import 'package:goodedunote/user/component/teacher_myedu_card.dart';
import 'package:goodedunote/user/model/student_model.dart';
import 'package:goodedunote/user/model/teahcer_model.dart';
import 'package:goodedunote/user/enum/user_enum.dart';
import 'package:goodedunote/user/model/user_model.dart';

/// 기능명 : User 이메일 양식 검증
/// true : 이메일 양식
/// false : 양식 아님
bool isEmailFormat (String userId){
  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(userId);
}

bool isPhoneNumberFormat (String userPhone){
  return RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$').hasMatch(userPhone);
}

UserModel getMyInfoFromStorage (String userData) {
  final jsonData = jsonDecode(userData);
  return createUserModelByGubun(jsonData);
}

UserModel createUserModelByGubun (Map<String,dynamic> map){

  UserModel userModel;

  USER_GUBUN user_gubun =confirmUserGubun(map['user_gubun']);

  if(USER_GUBUN.student == user_gubun ){
    userModel = StudentModel.fromJson(map);
  } else if(USER_GUBUN.teacher == user_gubun){
    userModel = TeacherModel.fromJson(map);
  } else {
    userModel = StudentModel.fromJson(map);
  }
  return userModel;
}

USER_GUBUN confirmUserGubun(String user_gubun){

  var gubunList = USER_GUBUN.values;
  var matchGubun = gubunList.firstWhere(
        (gubun) => gubun.toString().split('.').last == user_gubun,
  );
  return matchGubun;
}

STUDENT_GUBUN confirmStudentGubun(String studentGubun){

  var gubunList =  STUDENT_GUBUN.values;
  var matchGubun = gubunList.firstWhere(
        (gubun) => gubun.toString().split('.').last == studentGubun,
  );
  return matchGubun;
}
STUDENT_GUBUN confirmStudentGubunToEnum(String studentGubun){

  if (studentGubun == '초등'){
    return STUDENT_GUBUN.element;
  } else if (studentGubun == '중등'){
    return STUDENT_GUBUN.middle;
  } else if (studentGubun == '고등'){
    return STUDENT_GUBUN.high;
  } else {
    return STUDENT_GUBUN.all;
  }
}

String confirmStudentGubunToString(STUDENT_GUBUN studentGubun){

  if (studentGubun == STUDENT_GUBUN.element){
    return '초등';
  } else if (studentGubun == STUDENT_GUBUN.middle){
    return '중등';
  } else if (studentGubun == STUDENT_GUBUN.high){
    return '고등';
  } else {
    return '전체';
  }
}

LINKED_STATUS confirmLinkedStatus(String string_val){

  var enumList = LINKED_STATUS.values;

  var matchedVal = enumList.firstWhere(
        (val) => val.toString().split('.').last == string_val,
  );

  return matchedVal;
}

// 이메일 앞자리 암호화
String maskEmail(String email){
  int atIndex = email.indexOf('@');
  String prefix = email.substring(0, atIndex);

  if(prefix.length > 4){
    String maskedPart = '*' *4;
    String visiblePart = prefix.substring(0, prefix.length -4 );
    return visiblePart + maskedPart + email.substring(atIndex);
  } else {
    String maskedPart = '*' * prefix.length;
    return maskedPart + email.substring(atIndex);
  }
}

String maskPhoneNumber (String phoneNumber){
  List<String> numberList = phoneNumber.split('-');
  String maskedNumber = '${numberList[0]}-****-${numberList[2]}';
  return maskedNumber;
}

/// dynamic , dynamic > String, dynamic
Map<String,dynamic> convertJsonMap (Map<dynamic, dynamic> map){
  return jsonDecode(jsonEncode(map)) as Map<String,dynamic> ;
}

String createConnectId (String teacherId, String studentId){
  return teacherId + '@' + studentId;
}

Color getTargetStudentColor(STUDENT_GUBUN gubun){
  if(gubun == STUDENT_GUBUN.element) {
    return CONST_COLOR_ELEMENT;
  } else if (gubun == STUDENT_GUBUN.middle) {
    return CONST_COLOR_MIDDLE;
  } else if (gubun == STUDENT_GUBUN.high) {
    return CONST_COLOR_HIGH;
  } else {
    return CONST_COLOR_ALL;
  }
}
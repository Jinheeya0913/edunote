import 'package:goodedunote/common/const/const_response.dart';

class ResponseModel{
  final String responseCode;
  final String? responseMsg;
  // 81 회원가입에러
  final Map<String,dynamic>? responseMap;
  final Object? responseObj;

  ResponseModel({
    required this.responseCode,
    this.responseMsg,
    this.responseMap,
    this.responseObj,
  });


  static ResponseModel createSuccessResponseModel (){
    return ResponseModel(responseMsg: CONST_SUCCESS_MSG, responseCode: CONST_SUCCESS_CODE);
  }

  static ResponseModel createFailResponseModel (String msg){
    return ResponseModel(responseMsg: msg, responseCode: CONST_FAIL_CODE);
  }

}


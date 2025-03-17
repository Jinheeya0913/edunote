import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/func/commonFunc.dart';
import 'package:goodedunote/common/func/datetimeFunc.dart';
import 'package:goodedunote/common/model/fb_result_model.dart';
import 'package:goodedunote/common/provider/firebase/fb_storage_provider.dart';
import 'package:goodedunote/common/provider/firebase/firestore_con_req_provider.dart';
import 'package:goodedunote/common/provider/firebase/firestore_user_provider.dart';
import 'package:goodedunote/user/func/user_func.dart';
import 'package:goodedunote/user/model/connect_model.dart';
import 'package:goodedunote/user/model/student_model.dart';
import 'package:goodedunote/user/enum/user_enum.dart';
import 'package:goodedunote/user/model/teahcer_model.dart';
import 'package:goodedunote/user/provider/user_provider.dart';
import 'package:intl/intl.dart';

final studentProvider = Provider<StudentProvider>((ref) {
  final fireStorageProvider = ref.watch(fireStorageCustomProvider);
  final userManageProvider = ref.watch(userProvider.notifier);
  final fireUserProvider = ref.watch(fireStoreUsersProvider);
  final connReqProvider = ref.watch(fireStoreConnReqProvider);

  return StudentProvider(
    fireStorageCustomProvider: fireStorageProvider,
    userManageProvider: userManageProvider,
    fireUserProvider: fireUserProvider,
    connReqProvider: connReqProvider,
  );
});

class StudentProvider {
  final FireStorageCustomProvider fireStorageCustomProvider;
  final UserProvider userManageProvider;
  final FireStoreUserProvider fireUserProvider;
  final FireStoreConReqProvider connReqProvider;

  StudentProvider({
    required this.fireStorageCustomProvider,
    required this.userManageProvider,
    required this.fireUserProvider,
    required this.connReqProvider,
  });


  /// 학생 정보 refresh

  Future<ResponseModel> refreshStudentInfo(String userId) async {
    final refreshResult = await userManageProvider.refreshUserInfo(userId);
    return refreshResult;
  }

  /// 티처 찾기 (성공)
  Future<ResponseModel> searchTeacher(
      String studentId, String teacherId) async {
    TeacherModel? user;
    ConnectRequestModel? requestModel;
    ResponseModel responseModel;
    Map<String,dynamic>? requestData;
    Map<String,dynamic> resultMap = {};

    final searchResult = await fireUserProvider.readUserInfo(teacherId);

    // 1. 선생 데이터 조회
    if (searchResult.responseCode == CONST_SUCCESS_CODE) {
      print('searchTeacher >> 검색 성공');
      final searchMap = searchResult.responseObj as Map<String,dynamic>;

      if (confirmUserGubun(searchMap['user_gubun']) != USER_GUBUN.teacher) {
        return ResponseModel(responseCode: '01', responseMsg: '잘못된 유저 정보');
      }
      
      // 불필요한 연결 정보 삭제
      searchMap['connectInfo'] = null;

      // 기존 연결 요청 확인
      ResponseModel readResult  =
        await connReqProvider.readConnectRequest(studentId, teacherId);

      if(readResult.responseCode== CONST_SUCCESS_CODE && readResult.responseObj != null) {
        requestData = readResult.responseObj as Map<String,dynamic>;
      }

      resultMap.addAll({'teacherInfo' : searchMap});
      resultMap.addAll({'connectInfo' : requestData});

      return ResponseModel(
          responseCode: CONST_SUCCESS_CODE, responseObj: resultMap);
    } else {
      return ResponseModel(responseCode: CONST_FAIL_CODE, responseMsg: '조회결과 없음');
    }
  }


  /////////////////////////////////////////////////////
  // 학생 연결 요청                                     //
  /////////////////////////////////////////////////////

  /// 전체 연결 요청 내역 확인
  Future<List<ConnectRequestModel>> confirmAllConnectRequest(
      String userId, USER_GUBUN userGubun) async {
    List<ConnectRequestModel> resultList = [];
    ResponseModel response;

    final readResult =
        await connReqProvider.readAllConnectRequestList(userId, userGubun);

    if (readResult.responseCode==CONST_SUCCESS_CODE) {

      if(readResult.responseObj!=null) {
        print('data exist');
        final dataList = readResult.responseObj as List<Map<String, dynamic>>;
        print('data length : ${dataList.length}');
        for (var data in dataList) {
          var dataModel = ConnectRequestModel.fromJson(data);

          if (dataModel.linked_status != LINKED_STATUS.linked) {
            // 이미 연결이 돼 있는 것들은 추가 안함
            if (dataModel.linked_status != LINKED_STATUS.wait) {
              // 연결됨, 대기 이외의 것들은 수정 기간에 따라서 출력 여부 결정
              if (dataModel.modifyDt != null) {
                int difference = calculateDaysDifferenceFromNow(dataModel.modifyDt!);
                print('difference : $difference');
                if (difference < 7) {
                  resultList.add(dataModel);
                }
              }
            } else {
              // 상태가 대기중인 항목은 무조건 추가
              resultList.add(dataModel);
            }
          }
        }
      }
    }

    return resultList;
  }

  /// 티처에게 연결 요청하기
  Future<ResponseModel> requestConnectToTeacher({
    required TeacherModel teacher,
    required StudentModel student,
  }) async {

    print('student: ${jsonEncode(student.toJson())}');
    print('teacher: ${jsonEncode(teacher.toJson())}');

    // 요청 내용에 들어가는 사용자 정보에는 connectInfo가 제거되어야 함.
    teacher.connectInfo = null;
    student.connectInfo = null;

    String now = DateFormat("yyyy-MM-dd").format(DateTime.now());

    // 학생의 요청 목록에 담을 item
    ConnectRequestModel requestInfo = ConnectRequestModel(
      studentInfo: student.toJson(),
      studentId: student.userId,
      teacherInfo: teacher.toJson(),
      teacherId: teacher.userId,
      linked_status: LINKED_STATUS.wait,
      createDt: now,
    );

    ResponseModel fbResultModel =
        await connReqProvider.updateConnectRequest(requestInfo);

    return fbResultModel;
  }

  /// 연결 요청 상태 취소하기
  Future<ResponseModel> cancelConnectRequest(
      String studentId, String teacherId) async {
    ResponseModel result =
        await connReqProvider.updateStatusToRefused(studentId, teacherId);

    return result;
  }


  /////////////////////////////////////////////////////
  // connect 선생 정보 확인                             //
  /////////////////////////////////////////////////////

  Future<ResponseModel> getAllConnectedList(List<ConnectModel> connectList) async {
    List<TeacherModel> teacherList = [];
    if(connectList.isNotEmpty) {
      List<String> teachers = [];
      for (var connect in connectList) {
        teachers.add(connect.teacherId);
      }
      ResponseModel readListResult = await userManageProvider.getUserInfoList(teachers);

      if(readListResult.responseCode == CONST_SUCCESS_CODE){
        final resultMapList = readListResult.responseObj as List<Map<String,dynamic>>;
        teacherList = resultMapList.map((userData)=> TeacherModel.fromJson(userData)).toList();
        return ResponseModel(responseCode: CONST_SUCCESS_CODE, responseObj: teacherList);
      } else {
        return readListResult;
      }
    }else {
      return ResponseModel(responseCode: CONST_SUCCESS_NO_RESULT_CODE, responseMsg: CONST_SUCCESS_NO_RESULT_MSG);
    }
  }
}

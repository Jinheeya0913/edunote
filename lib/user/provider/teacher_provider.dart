import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/func/datetimeFunc.dart';
import 'package:goodedunote/common/model/fb_result_model.dart';
import 'package:goodedunote/common/provider/firebase/firestore_con_req_provider.dart';
import 'package:goodedunote/user/enum/user_enum.dart';
import 'package:goodedunote/user/func/user_func.dart';
import 'package:goodedunote/user/model/connect_model.dart';
import 'package:goodedunote/user/model/student_model.dart';
import 'package:goodedunote/user/model/teahcer_model.dart';
import 'package:goodedunote/user/provider/user_provider.dart';

final teacherProvider = Provider<TeacherProvider>((ref) {
  final userManageProvider = ref.watch(userProvider.notifier);
  final fireConReqProvider = ref.watch(fireStoreConnReqProvider);
  return TeacherProvider(
    userManageProvider: userManageProvider,
    fireConReqProvider: fireConReqProvider,
  );
});

class TeacherProvider {
  final UserProvider userManageProvider;
  final FireStoreConReqProvider fireConReqProvider;

  TeacherProvider({
    required this.userManageProvider,
    required this.fireConReqProvider,
  });

  /// 선생 정보 refresh

  Future<ResponseModel> refreshTeacherInfo(String userId) async {
    final refreshResult = await userManageProvider.refreshUserInfo(userId);
    return refreshResult;
  }

  /////////////////////////////////////////////////////
  // 연결된 학생 확인                                   //
  /////////////////////////////////////////////////////

  Future<ResponseModel> getAllConnectedStudentList(
      List<ConnectModel> connectList) async {
    List<String> studentIdList = [];
    List<StudentModel> studentList = [];

    for (var connectInfo in connectList) {
      studentIdList.add(connectInfo.studentId);
    }

    ResponseModel readResult =
        await userManageProvider.getUserInfoList(studentIdList);

    if (readResult.responseCode == CONST_SUCCESS_CODE) {
      List<Map<String, dynamic>> resultMapList =
          readResult.responseObj! as List<Map<String, dynamic>>;
      for (var userMap in resultMapList) {
        studentList.add(StudentModel.fromJson(userMap));
      }
      return ResponseModel(
          responseCode: CONST_SUCCESS_CODE, responseObj: studentList);
    }

    return readResult;
  }

  /////////////////////////////////////////////////////
  // 전체 연결 요청 확인                                 //
  /////////////////////////////////////////////////////

  /// 전체 연결 요청 확인
  Future<ResponseModel> confirmAllConnectRequest(String teacherId, USER_GUBUN userGubun) async {
    List<ConnectRequestModel> resultList = [];
    try {
      ResponseModel response =
          await fireConReqProvider.readAllConnectRequestList(teacherId, userGubun);

      if (response.responseCode == CONST_SUCCESS_CODE) {
        if (response.responseObj != null) {
          final dataList = response.responseObj as List<Map<String, dynamic>>;

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
    } catch (e) {
      print('confirmAllConRequest >> error : $e');
      return ResponseModel.createFailResponseModel('요청 처리 중 실패하였습니다');
    }
    return ResponseModel(
        responseCode: CONST_SUCCESS_CODE, responseObj: resultList);
  }

  /// 요청 수락 하기
  /// 1. 학생의 정보와 선생의 정보를 가져온다
  /// 2. 연결 정보를 추가한다.
  /// 3. 추가한 내용을 유저 정보에 저장한다.
  Future<ResponseModel> acceptConnectRequest(
      TeacherModel teacher, StudentModel student) async {
    // new connect info

    String connectId = createConnectId(teacher.userId, student.userId);
    List<ConnectModel>? teacherConList = teacher.connectInfo;
    List<ConnectModel>? studentConList = student.connectInfo;

    ConnectModel connect = ConnectModel(
      connectId: connectId,
      studentId: student.userId,
      teacherId: teacher.userId,
      linked_status: LINKED_STATUS.linked,
      createDt: getNow(),
    );

    // 학생 및 선생 정보 처리
    try {
      // 기존 connect 리스트 추출

      if (teacherConList != null) {
        teacherConList.add(connect);
      } else {
        teacherConList = [connect];
      }

      if (studentConList != null) {
        studentConList.add(connect);
      } else {
        studentConList = [connect];
      }

      // connect 요청에서 상태값을 wait - > linked로 변경
      ResponseModel conReqUpdateResult = await fireConReqProvider
          .updateStatusToLinked(student.userId, teacher.userId);

      // 회원정보의 connectInfo List에 추가
      if (conReqUpdateResult.responseCode == CONST_SUCCESS_CODE) {
        final saveStudentResult =
            await userManageProvider.updateConnectInfo(student, connect);
        final saveTeacherResult =
            await userManageProvider.updateConnectInfo(teacher, connect);

        if (saveStudentResult.responseCode == CONST_SUCCESS_CODE &&
            saveTeacherResult.responseCode == CONST_SUCCESS_CODE) {
          // CONNECT 정보를 성공적으로 저장했다면 provider와 storage의 유저 정보도 갱신
          await userManageProvider.setUserState(teacher);
          return ResponseModel.createSuccessResponseModel();
        } else {
          // await userManageProvider.updateUserProfile(beforeStudentInfo);
          // await userManageProvider.updateUserProfile(beforeTeacherInfo);
          return saveTeacherResult;
        }
      } else {
        return conReqUpdateResult;
      }
    } catch (e) {
      print('teacherProvider >> acceptConnectRequest >> e : $e');
      return ResponseModel.createFailResponseModel(CONST_USERINFO_FAIL_MSG);
    }
  }

  /// 요청 거절하기 Todo 작성할 것
  Future<ResponseModel> refuseConnectRequest(
      String teacherId, String studentId) async {
    ResponseModel response = ResponseModel.createFailResponseModel('msg');
    // await connectsProvider.refuseConnectRequest(studentId, teacherId);
    return response;
  }
}

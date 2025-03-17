import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/func/commonFunc.dart';
import 'package:goodedunote/common/func/datetimeFunc.dart';
import 'package:goodedunote/common/model/fb_result_model.dart';
import 'package:goodedunote/user/enum/user_enum.dart';
import 'package:goodedunote/user/func/user_func.dart';
import 'package:goodedunote/user/model/connect_model.dart';
import 'package:riverpod/riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final fireStoreConnReqProvider = Provider<FireStoreConReqProvider>(
  (ref) => FireStoreConReqProvider(
    ref: FirebaseFirestore.instance.collection('connectRequests'),
  ),
);

/// connect 연결 요청에 대한 처리를 맡은 provider
class FireStoreConReqProvider {
  final CollectionReference ref;

  FireStoreConReqProvider({
    required this.ref,
  });

  ////////////////////////////////////////
  //                공통                //
  ///////////////////////////////////////

  /// 대상에 대한 요청 내역 확인 (공통)
  Future<ResponseModel> readConnectRequest(
      String studentId, String teacherId) async {
    try {
      final readResult = await ref
          .where('studentId', isEqualTo: studentId)
          .where('teacherId', isEqualTo: teacherId)
          .get();
      if (readResult.docs.isNotEmpty) {
        print('readRequestStatus >> 조회 결과 있음');
        final resultData = readResult.docs[0];
        final info = resultData.data();
        return ResponseModel(
            responseCode: CONST_SUCCESS_CODE, responseObj: info);
      } else {
        return ResponseModel.createSuccessResponseModel();
      }
    } on FirebaseException catch (fe) {
      print('readRequestStatus >> fe >> $fe');
      return ResponseModel.createFailResponseModel('조회 실패');
    } catch (e) {
      print('readRequestStatus >> e >> $e');
      return ResponseModel.createFailResponseModel('서버 오류');
    }
  }

  /// 모든 connect 요청 정보 읽어오기
  Future<ResponseModel> readAllConnectRequestList(String userId, USER_GUBUN userGubun) async {
    List<Map<String, dynamic>> searchList = [];
    String searchGubun = '';

    if(userGubun==USER_GUBUN.student){
      searchGubun = 'studentId';
    } else if (userGubun ==USER_GUBUN.teacher){
      searchGubun = 'teacherId';
    } else {
      // Todo 학부모 추가
      searchGubun = 'teacherId';
    }

    try {
      final readResult = await ref.where(searchGubun, isEqualTo: userId).get();

      if (readResult.docs.isNotEmpty) {
        for (var val in readResult.docs) {
          Map<String, dynamic> data = val.data() as Map<String, dynamic>;
          searchList.add(data);
        }
        return ResponseModel(
            responseCode: CONST_SUCCESS_CODE, responseObj: searchList);
      } else {
        return ResponseModel.createSuccessResponseModel();
      }
    } on FirebaseException catch (fe) {
      print('readAllConnectRequestList >> fe : $fe ');
      return ResponseModel.createFailResponseModel('요청 처리 중 실패하였습니다.');
    } catch (e) {
      print('readAllConnectRequestList >> e : $e ');
      return ResponseModel.createFailResponseModel('서버 에러');
    }
  }

  /// connect 요청 정보 wait->linked로 변환
  Future<ResponseModel> updateStatusToLinked(String studentId, String teacherId) async {
    try {
      QuerySnapshot querySnapshot = await ref
          .where('teacherId', isEqualTo: teacherId)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        await documentSnapshot.reference.update({
          'modifyDt': getNow(),
          'linked_status' : 'linked',
        });
        return ResponseModel.createSuccessResponseModel();
      } else {
        return ResponseModel.createFailResponseModel(CONST_USERINFO_FAIL_MSG);
      }
    } on FirebaseException catch (fe) {
      print('updateStatusToLinked >> fe : $fe ');
      return ResponseModel.createFailResponseModel(CONST_USERINFO_FAIL_MSG);
    } catch (e) {
      print('updateStatusToLinked >> e : $e ');
      return ResponseModel.createFailResponseModel('서버 에러');
    }
  }
  /// connect 요청 정보 거절 
  Future<ResponseModel> updateStatusToRefused(String studentId, String teacherId) async {
    try{ 
      QuerySnapshot querySnapshot = await ref
          .where('studentId', isEqualTo: studentId)
          .where('teacherId', isEqualTo: teacherId)
          .get();

      print('studentId : $studentId');
      print('teacherId : $teacherId');

      if(querySnapshot.docs.isNotEmpty){
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        await documentSnapshot.reference.update({'linked_status' : 'refused'});
        return ResponseModel.createSuccessResponseModel();
      } else {
        return ResponseModel(responseCode: CONST_CON_REQ_NOT_EXIST_CODE, responseMsg: CONST_CON_REQ_NOT_EXIST_MSG);
      }
    
    } on FirebaseException catch (fe) {
        print('updateStatusToRefused >> fe : $fe ');
        return ResponseModel(responseCode: CONST_FIRESTORE_ERROR_CODE, responseMsg: CONST_FIRESTORE_ERROR_MSG);
    } catch (e){
        print('updateStatusToRefused >> e : $e ');
        return ResponseModel.createFailResponseModel('서버 오류가 발생하였습니다');
    }
  }

  ////////////////////////////////////////
  //                학생                //
  ///////////////////////////////////////

  /// Connect 요청
  Future<ResponseModel> updateConnectRequest(
      ConnectRequestModel connectRequest) async {
    try {
      print('updateConnectRequest >> ${connectRequest.toJson()}');

      final result = await ref.add(connectRequest.toJson());
      print('saveConnectRequest ${result.toString()}');
      return ResponseModel.createSuccessResponseModel();
    } on FirebaseException catch (fe) {
      print('saveConnectRequest fe >> $fe');
      return ResponseModel.createFailResponseModel('요청 저장 중 요류가 발생하였습니다');
    } catch (e) {
      print('saveConnectRequest e >> $e');
      return ResponseModel.createFailResponseModel('서버 에러. 관리자에게 문의해주세요.');
    }
  }

////////////////////////////////////////
//                선생                //
///////////////////////////////////////
}

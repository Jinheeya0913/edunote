import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/model/fb_result_model.dart';
import 'package:goodedunote/user/model/connect_model.dart';
import 'package:goodedunote/user/model/user_model.dart';
import 'package:riverpod/riverpod.dart';

final fireStoreUsersProvider = Provider<FireStoreUserProvider>(
  (ref) => FireStoreUserProvider(
    ref: FirebaseFirestore.instance.collection('users'),
  ),
);

class FireStoreUserProvider {
  final CollectionReference ref;

  FireStoreUserProvider({
    required this.ref,
  });

  /// 세부정보 저장 (성공)
  Future<ResponseModel> saveUserInfo(UserModel model) async {
    final userData = model.toJson();
    print('UserDB > saveUserInfo > userData : ${userData.toString()}');

    try {
      ref.add(userData).then((DocumentReference ref) =>
          print('docsnapshot added with ID : ${ref.id}'));
      return ResponseModel(responseCode: CONST_SUCCESS_CODE);
    } on FirebaseException catch (fe) {
      print('userDB > saveUserInfo > firebase Error : $fe');
      return ResponseModel.createFailResponseModel('회원정보 저장 중 오류가 발생하였습니다.');
    } catch (e) {
      print('UserDB > saveUserInfo > error : $e');
      return ResponseModel.createFailResponseModel('회원정보 저장 중 오류가 발생하였습니다');
    }
  }

  /// userId 중복 확인
  Future<ResponseModel> isDuplicateId(String userId) async {
    try {
      final searchResult = await ref.where('userId', isEqualTo: userId).get();
      if (searchResult.docs.isNotEmpty) {
        return ResponseModel.createFailResponseModel('이미 존재하는 ID입니다');
      } else {
        return ResponseModel.createSuccessResponseModel();
      }
    } on FirebaseException catch (fe) {
      print('fe error : $fe');
      return ResponseModel.createFailResponseModel(
          '올바르지 않은 요청입니다. 관리자에게 문의하세요.');
    } catch (e) {
      print('e error : $e');
      return ResponseModel.createFailResponseModel('서버 오류');
    }
  }

  /// 회원정보 조회 (성공)
  Future<ResponseModel> readUserInfo(String userId) async {
    try {
      final readResult = await ref
          .where(
            'userId',
            isEqualTo: userId,
          )
          .get();
      if (readResult.docs.isNotEmpty) {
        final info = readResult.docs[0];
        print(info.data());
        return ResponseModel(
            responseCode: CONST_SUCCESS_CODE, responseObj: info.data() as Map<String,dynamic> );
      } else {
        return ResponseModel.createFailResponseModel(
            '유효하지 않는 계정입니다. 다시 시도해주세요.');
      }
    } catch (e) {
      print('readUserInfo2 > error : $e');
      return ResponseModel.createFailResponseModel('서버 에러');
    }
  }

  /// 회원정보 List 조회
  Future<ResponseModel> readUserInfoList(List<String> userIdList) async {
    // whereIn은 최대 10개의 문서만 조회할 수 있음
    // 그러므로 10개 이상에 대해서는 여러 번 조회를 해야 함.
    List<String> batch = [];
    List<Map<String, dynamic>> resultMapList = [];
    try {
      // int i= 0 일 때 --> 10번째까지의 userId를 조회함
      // int i= 1 일 때 --> 11번째(i=+10 으로 증가)부터 20번째 userId를 조회함
      // int i= 2 -------->
      for (int i = 0; i < userIdList.length; i += 10) {
        batch = userIdList.sublist(
            i, (i + 10 > userIdList.length) ? userIdList.length : i + 10);
        final resultSnapshot = await ref.where('userId', whereIn: batch).get();
        if (resultSnapshot.docs.isNotEmpty) {
          resultMapList.addAll(resultSnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList());
        } else {
          return ResponseModel(responseCode: CONST_SUCCESS_NO_RESULT_CODE, responseMsg: CONST_SUCCESS_NO_RESULT_MSG);
        }
      }

      return ResponseModel(responseCode: CONST_SUCCESS_CODE, responseObj: resultMapList);

    } on FirebaseException catch (fe) {
      print('readUserInfoList >> fe : $fe ');
      return ResponseModel.createFailResponseModel('요청 중 오류가 발생하였습니다');
    } catch (e) {
      print('readUserInfoList >> e : $e ');
      return ResponseModel.createFailResponseModel('서버 오류');
    }
  }

  Future<ResponseModel> updateUserImgUrl(String userId, String imgUrl  ) async {

    try{
      QuerySnapshot snapshot = await ref.where('userId', isEqualTo: userId).get();
      if(snapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = snapshot.docs.first;
        await userDoc.reference.update({'userImgUrl' : imgUrl});
        return ResponseModel.createSuccessResponseModel();
      }
    } on FirebaseException catch (fe) {
        print('updateUserImgUrl >> fe : $fe ');
    } catch (e){
        print('updateUserImgUrl >> e : $e ');
    }

    return ResponseModel.createFailResponseModel('업데이트 실패 하였습니다');
  }

  /// 회원 connect 정보 update
  Future<ResponseModel> updateUserConnectInfo(
      String userId, List<ConnectModel> connectList) async {
    try {
      final jsonList = connectList.map((connect) => connect.toJson()).toList();
      final QuerySnapshot snapshot =
          await ref.where('userId', isEqualTo: userId).get();
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = snapshot.docs.first;
        await userDoc.reference.update({'connectInfo': jsonList});
        return ResponseModel.createSuccessResponseModel();
      } else {
        return ResponseModel.createFailResponseModel(
            '유저 정보를 찾지 못했습니다! 관리자에게 문의하세요.');
      }
    } on FirebaseException catch (fe) {
      print('updateUserConnectInfo >> fe : $fe ');
      return ResponseModel.createFailResponseModel('요청 처리 중 에러가 발생하였습니다');
    } catch (e) {
      print('updateUserConnectInfo >> e : $e ');
      return ResponseModel.createFailResponseModel('서버 에러');
    }
  }
}

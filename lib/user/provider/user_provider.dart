import 'dart:convert';
import 'dart:io';

import 'package:goodedunote/common/auth/auth_model.dart';
import 'package:goodedunote/common/const/const_data.dart';
import 'package:goodedunote/common/model/fb_result_model.dart';
import 'package:goodedunote/common/provider/firebase/fb_auth_provider.dart';
import 'package:goodedunote/common/provider/firebase/fb_storage_provider.dart';
import 'package:goodedunote/common/provider/firebase/firestore_user_provider.dart';
import 'package:goodedunote/common/provider/image_provider.dart';
import 'package:goodedunote/common/provider/secure_storage_provider.dart';
import 'package:goodedunote/user/func/user_func.dart';
import 'package:goodedunote/user/enum/user_enum.dart';
import 'package:goodedunote/user/model/connect_model.dart';
import 'package:goodedunote/user/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../common/const/const_response.dart';

final userProvider = StateNotifierProvider<UserProvider, UserBaseModel?>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final authProvider = ref.watch(auth_Provider);
  final fireStorageProvider = ref.watch(fireStorageCustomProvider);
  final fireStoreUserProvider = ref.watch(fireStoreUsersProvider);
  final imgProvider = ref.watch(imageProvider);

  return UserProvider(
    storage: storage,
    authProvider: authProvider,
    fireStorageProvider: fireStorageProvider,
    fireStoreUserProvider: fireStoreUserProvider,
    imageProvider: imgProvider ,
  );
});

class UserProvider extends StateNotifier<UserBaseModel?> {
  final FlutterSecureStorage storage;
  final AuthCustomProvider authProvider;

  final FireStorageCustomProvider fireStorageProvider;
  final FireStoreUserProvider fireStoreUserProvider;

  final ImageProvider imageProvider;

  UserProvider({
    required this.storage,
    required this.authProvider,
    required this.fireStorageProvider,
    required this.fireStoreUserProvider,
    required this.imageProvider,
  }) : super(UserLoadingModel()) {
    // logout();
    getMe();
  }

  ////////////////////////////////////////////
  //                 유 저 조 회            ///
  ///////////////////////////////////////////

  /// 내 정보 조회
  Future<void> getMe() async {
    print('[userProvider] >> getMe >> 수행');
    try {
      final userInfo = await storage.read(key: USER_INFO);
      if (userInfo == null) {
        print('[userProvider] >> getMe >> 로그인 안 돼 있음');
        state = null;
        return;
      } else {
        print('[userProvider] >> getMe >> 유저정보 있음');
        var mapData = jsonDecode(userInfo);
        var model = createUserModelByGubun(mapData);

        state = model;
        // print(data.keys);
        // print(data['user_gubun']);
      }
    } catch (e){
      print('[userProvider] >> getMe >> 에러. 사용자 정보 초기화');
      logout();
    }
  }

  /// 유저 정보 조회
  Future<UserModel?> getUserInfo(String userId) async {
    final readResult =  await fireStoreUserProvider.readUserInfo(userId);

    if(readResult.responseCode == CONST_SUCCESS_CODE){
      final userData = readResult.responseObj as Map<String,dynamic>;
      final user = createUserModelByGubun(userData);
      return user;
    }

    return null;
  }

  /// 유저 정보 조회 List
  Future<ResponseModel> getUserInfoList(List<String> userIdList) async {
    ResponseModel readListResult =await fireStoreUserProvider.readUserInfoList(userIdList);

    return readListResult;
  }

  /// 유저 정보 갱신
  Future<ResponseModel> refreshUserInfo(String userId) async {
      final user = await this.getUserInfo(userId);
      if(user!=null){
        return await setUserState(user);
      } else {
        return ResponseModel(responseCode: CONST_USER_REFRESH_FAIL_CODE, responseMsg: CONST_USER_REFRESH_FAIL_MSG);
      }
  }


  /// provider, storage 내부의 유저 정보 새로 고침
  Future<ResponseModel> setUserState(UserModel user) async {
    state = user;
    await storage.write(key: USER_INFO, value: user.toJson().toString());
    return ResponseModel(responseCode: CONST_SUCCESS_CODE, responseObj: user);
  }


  /// FireStore login
  Future<UserBaseModel> login({
    required String userId,
    required String userPw,
    required USER_GUBUN userGubun,
  }) async {
    try {
      final readResult = await fireStoreUserProvider.readUserInfo(userId);
      String errorMsg;
      if (readResult.responseCode == CONST_SUCCESS_CODE) {
        final user = readResult.responseObj as Map<String, dynamic>;
        var userEmail = user['userEmail'];

        AuthModel authModel = await authProvider.signIn(userEmail, userPw);

        if (authModel.authResultCode == CONST_SUCCESS_CODE) {
          final userModel = createUserModelByGubun(user);

          if (userModel.user_gubun != userGubun) {
            errorMsg = '로그인에 실패하였습니다';
            print('구분값 안 맞음');
            state = UserErrorModel(message: errorMsg);
          } else {
            await storage.write(key: USER_INFO, value: jsonEncode(user));
            print('list : ${userModel.connectInfo.toString()}');
            state = userModel;
          }
        } else {
          errorMsg = '로그인에 실패하였습니다';
          state = UserErrorModel(message: errorMsg);
        }
      } else {
        errorMsg = '로그인에 실패하였습니다';
        state = UserErrorModel(message: errorMsg);
      }

      return Future.value(state);
    } catch (e) {
      print(e);
      state = UserErrorModel(message: '로그인에 실패하였습니다');
      return Future.value(state);
    }
  }

  /// 로그아웃
  Future<bool> logout() async {
    print('로그아웃');
    state = null;
    Future.wait([storage.delete(key: USER_INFO)]);
    return true;
  }


  ////////////////////////////////////////////
  //                 유 저 생 성            ///
  ///////////////////////////////////////////

  /// 회원가입
  Future<ResponseModel> join({required UserModel model}) async {
    final checkResult = await fireStoreUserProvider.isDuplicateId(model.userId);

    ResponseModel result;

    if (checkResult.responseCode == CONST_SUCCESS_CODE) {
      final joinResult =
          await authProvider.signUp(model.userEmail, model.userPw!);

      model.userPw = null;

      if (joinResult.authResultCode != CONST_SUCCESS_CODE) {
        result = ResponseModel(
          responseCode: CONST_JOIN_ERROR_CODE,
          responseMsg: joinResult.authResultMsg,
        );
      } else {
        print('userProvider >> auth 저장 성공');
        final saveResult = await fireStoreUserProvider.saveUserInfo(model);
        if (saveResult.responseCode != CONST_SUCCESS_CODE) {
          print('user 삭제');
          final deleteResult =
              await authProvider.cancelUserJoin(joinResult.userInfo!);
          if (deleteResult.authResultCode == CONST_USERINFO_FAIL_CODE) {
            return ResponseModel.createFailResponseModel(
                deleteResult.authResultMsg!);
          }
          result = saveResult;
        } else {
          result = ResponseModel.createSuccessResponseModel();
        }
      }
    } else {
      print('userProvider >> fb > 중복 ID 있음');
      return checkResult;
    }

    return result;
  }

  /// 유저 정보 수정
  Future<ResponseModel> updateUserProfile(UserModel user) async {
    final response = await fireStoreUserProvider.saveUserInfo(user);
    return response;
  }

  /// 연결 정보 update // 전환작업 진행중
  Future<ResponseModel> updateConnectInfo(
      UserModel userModel, ConnectModel connectModel) async {
    List<ConnectModel> connectList = [];

    if (userModel.connectInfo != null) {
      if (userModel.connectInfo!.isNotEmpty) {
        print('not null & size > 0');
        connectList = userModel.connectInfo!;
      }
    }

    connectList.add(connectModel);
    userModel.connectInfo = connectList;

    return await fireStoreUserProvider.updateUserConnectInfo(
        userModel.userId, connectList);
  }

  /// 프로필 사진 업로드
  Future<ResponseModel> uploadProfileImg(UserModel user, File file) async {
    String userId  = user.userId;
    //1. storage 이미지 저장
    final uploadResponse =  await fireStorageProvider.uploadProfileImg(userId, file);

    if(uploadResponse.responseCode==CONST_SUCCESS_CODE) {

      //2. 유저 정보에 imUrl 저장
      final fileUrl = uploadResponse.responseObj as String;
      final updateResult = await fireStoreUserProvider.updateUserImgUrl(userId, fileUrl);

      user.userImgUrl = fileUrl;
      state = user;
      await storage.write(key: USER_INFO, value: jsonEncode(user));

      if(updateResult.responseCode==CONST_SUCCESS_CODE){
        // 3. 캐시에 이미지 저장
        final saveResponse = await imageProvider.saveProfileImageToApp(file, userId);
        return saveResponse;
      } else {
        return updateResult;
      }

    } else {
      return ResponseModel.createFailResponseModel(uploadResponse.responseMsg!);
    }


  }

}

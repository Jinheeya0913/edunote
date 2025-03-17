import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodedunote/common/auth/auth_model.dart';
import 'package:goodedunote/common/const/const_response.dart';

final auth_Provider = Provider<AuthCustomProvider>(
      (ref) =>
      AuthCustomProvider(
        authentication: FirebaseAuth.instance,
      ),
);

class AuthCustomProvider {
  final FirebaseAuth authentication;

  AuthCustomProvider({
    required this.authentication,
  });

  /// 회원가입
  Future<AuthModel> signUp(String userId, String userPw) async {
    try {
      final newUser = await authentication.createUserWithEmailAndPassword(
          email: userId, password: userPw);
      if (newUser.user != null) {
        return AuthModel(authResultMsg: newUser.user!.uid,
            authResultCode: '00',
            userInfo: newUser);
      } else {
        return AuthModel(
          authResultMsg: '회원가입 실패.', authResultCode: CONST_JOIN_ERROR_CODE,);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return AuthModel(authResultMsg: '취약한 비밀번호입니다!.',
          authResultCode: CONST_JOIN_ERROR_CODE,);
      } else if (e.code == 'email-already-in-use') {
        return AuthModel(authResultMsg: '이미 존재하는 계정입니다.',
          authResultCode: CONST_JOIN_ERROR_CODE,);
      } else {
        return AuthModel(
          authResultMsg: '$e.', authResultCode: CONST_JOIN_ERROR_CODE,);
      }
    } catch (e) {
      return AuthModel(
        authResultMsg: '기타 에러 : $e.', authResultCode: CONST_JOIN_ERROR_CODE,);
    }
  }

  /// 회원 정보 삭제
  Future<AuthModel> cancelUserJoin(UserCredential credential) async {
    try {
      await credential.user!.delete();
      return AuthModel(authResultCode: CONST_SUCCESS_CODE);
    } catch (e){
      print('삭제 실패');
      return AuthModel(authResultCode: CONST_USERINFO_FAIL_CODE);
    }
  }

  /// Login
  Future<AuthModel> signIn(String userEmail, String userPw) async {
    String? authResultMsg;
    String? authResultCode;

    try {
      final userInfo = await authentication.signInWithEmailAndPassword(
          email: userEmail, password: userPw);

      authResultCode = '00';
      authResultMsg = '로그인 성공';
      print('uid : ${userInfo.user!.uid}');

      AuthModel authModel = AuthModel(
        userInfo: userInfo,
        authResultMsg: authResultMsg,
        authResultCode: authResultCode,
      );

      return authModel;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        authResultMsg = '사용자가 존재하지 않습니다';
        authResultCode = '01';
      } else if (e.code == 'wrong-password') {
        authResultMsg = '비밀번호를 확인하세요.';
        authResultCode = '02';
      } else if (e.code == 'invalid-email') {
        authResultMsg = '잘못된 이메일입니다.';
        authResultCode = '03';
      } else {
        authResultCode = "99";
      }

      AuthModel authModel = AuthModel(
          authResultMsg: authResultMsg, authResultCode: authResultCode);

      return authModel;
    }
  }
}

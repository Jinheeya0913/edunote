import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {
  final UserCredential? userInfo;
  final String authResultCode;
  final String? authResultMsg;

  AuthModel({
    required this.authResultCode,
    this.userInfo,
    this.authResultMsg,
  });
}

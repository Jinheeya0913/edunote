import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/model/fb_result_model.dart';

final fireStorageCustomProvider = Provider<FireStorageCustomProvider>(
  (ref) => FireStorageCustomProvider(
    storage: FirebaseStorage.instance,
  ),
);

class FireStorageCustomProvider {
  final FirebaseStorage storage;

  FireStorageCustomProvider({
    required this.storage,
  });

  Future<ResponseModel> uploadProfileImg(String userId, File file) async {
    String basePath = 'user/profileImg';

    try {
      final uploadResult = await storage.ref(basePath).child(userId).putFile(file, SettableMetadata(
        contentType: "image/jpeg",
      ));

      String fileURL = await uploadResult.ref.getDownloadURL();
      return ResponseModel(responseCode: CONST_SUCCESS_CODE, responseObj: fileURL);

    } on FirebaseException catch (fe){
      print('fireStorageProvider > uploadImg > error');
      print(fe);
      return ResponseModel(responseCode: CONST_USERINFO_FAIL_CODE, responseMsg: CONST_USERINFO_FAIL_MSG);
    } catch (e){
      print('fireStorageProvider > uploadImg > error');
      return ResponseModel.createFailResponseModel('사진 업로드 실패');
    }
  }

  Future<ResponseModel> testUpload() async {
    final ref = storage.ref('test');
    ref.putString('hello world');
    return ResponseModel.createSuccessResponseModel();
  }

  Future<void> getProfileImg() async {

  }


}

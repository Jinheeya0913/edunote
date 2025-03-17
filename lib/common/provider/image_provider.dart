import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/model/fb_result_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

final imageProvider = Provider<ImageProvider>(
  (ref) => ImageProvider(),
);

class ImageProvider {

  Future<ResponseModel> saveProfileImageToApp(File file, String userId) async {
    try {
      final cashDir = await getTemporaryDirectory();
      final filePath = '${cashDir.path}/profileImg/$userId';

      // 디렉토리 생성
      final targetDirectory = Directory('${cashDir.path}/profileImg');

      if (!await targetDirectory.exists()) {
        await targetDirectory.create(recursive: true);
      }

      final savedFile = await file.copy(filePath);

      print('saveProfileImageToApp > $filePath');
      return ResponseModel(
          responseCode: CONST_SUCCESS_CODE, responseObj: filePath);
    } catch (e) {
      print('saveProfileImageToApp >> e : $e');
      return ResponseModel.createFailResponseModel('이미지 기기 저장 실패');
    }
  }

  Future<ResponseModel> getProfileImg(String userId) async {
    final cashDir = await getTemporaryDirectory();
    final filePath = '${cashDir.path}/profileImg/$userId';
    try {
      // 파일 존재 여부 확인
      final file = File(filePath);

      if (await file.exists()) {
        return ResponseModel(
            responseCode: CONST_SUCCESS_CODE, responseObj: filePath);
      } else {
        return ResponseModel.createFailResponseModel('존재하지 않는 캐시 이미지');
      }
    } catch (e){
      return ResponseModel.createFailResponseModel('이미지 불러오기 실패');
    }


  }
}

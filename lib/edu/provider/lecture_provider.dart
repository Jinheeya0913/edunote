import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/model/fb_result_model.dart';
import 'package:goodedunote/common/provider/firebase/firestore_lecture_provider.dart';
import 'package:goodedunote/edu/model/lecture_model.dart';

final lectureProvider = Provider<LectureProvider>((ref) {
  final fireLectureProvider = ref.read(fireStoreLectureProvider);
  return LectureProvider(
    fireLectureProvider: fireLectureProvider,
  );
});

class LectureProvider {
  final FireStoreLectureProvider fireLectureProvider;

  LectureProvider({
    required this.fireLectureProvider,
  });


  /// 새 강의 정보 생성
  Future<ResponseModel> createNewLecture(LectureModel lectureModel) async {
    final saveResult = await fireLectureProvider.createNewLecture(lectureModel);
    return saveResult;
  }


  /// 강의 정보 조회 (리스트)
  Future<ResponseModel> getLectureListByKeyword(
      String keyword, String searchGubun) async {
    List<LectureModel> lectureList;

    final result =
        await fireLectureProvider.readLectureListByGubun(keyword, searchGubun);
    if (result.responseCode == CONST_SUCCESS_CODE) {
      var dataList = result.responseObj as List<Map<String, dynamic>>;
      if (dataList.isEmpty) {
        return ResponseModel.createFailResponseModel('존재 하지 않는 강의입니다');
      } else {
        print('dataList length : ${dataList.length}');

        lectureList = dataList.map((dataMap) {
          return LectureModel.fromJson(dataMap);
        }).toList();

        return ResponseModel(
            responseCode: CONST_SUCCESS_CODE, responseObj: lectureList);
      }
    }
    return ResponseModel.createFailResponseModel('msg');
  }


}

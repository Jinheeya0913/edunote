import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/model/fb_result_model.dart';
import 'package:goodedunote/common/provider/firebase/firestore_lecture_provider.dart';
import 'package:goodedunote/edu/model/lecture_apply_model.dart';
import 'package:goodedunote/edu/model/lecture_model.dart';

final lectureApplyProvider = Provider<LectureApplyProvider>((ref) {
  final fireLectureProvider = ref.read(fireStoreLectureProvider);
  return LectureApplyProvider(
    fireLectureProvider: fireLectureProvider,
  );
});

class LectureApplyProvider {
  final FireStoreLectureProvider fireLectureProvider;

  LectureApplyProvider({
    required this.fireLectureProvider,
  });


  /// Todo 강의신청 보내기
  Future<ResponseModel> sendApplyLecture(LectureApplyModel applyModel) async {
    print('lectureApplyProvider > sendApplyLecture START');
    final createResponse = await fireLectureProvider.createLectureApply(applyModel);

    return createResponse;

  }



}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/func/firestore_func.dart';
import 'package:goodedunote/common/model/fb_result_model.dart';
import 'package:goodedunote/edu/model/lecture_apply_model.dart';
import 'package:goodedunote/edu/model/lecture_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fireStoreLectureProvider = Provider<FireStoreLectureProvider>((ref) {
  final lecture_ref = FirebaseFirestore.instance.collection('lectures');
  final applies_ref = FirebaseFirestore.instance.collection('lectureApplies');
  return FireStoreLectureProvider(
    lecture_ref: lecture_ref,
      applies_ref: applies_ref,
  );
});

class FireStoreLectureProvider {
  final CollectionReference lecture_ref;
  final CollectionReference applies_ref;

  FireStoreLectureProvider(
      {required this.lecture_ref, required this.applies_ref});

  /// 새 강의 정보 생성
  Future<ResponseModel> createNewLecture(LectureModel lectureModel) async {
    try {
      await lecture_ref.add(lectureModel.toJson());
      return ResponseModel.createSuccessResponseModel();
    } on FirebaseException catch (fe) {
      print('saveNewLecture >> fe : $fe ');
      return ResponseModel(
          responseCode: CONST_FIRESTORE_ERROR_CODE,
          responseMsg: CONST_FIRESTORE_ERROR_MSG);
    } catch (e) {
      print('saveNewLecture >> e : $e ');
      return ResponseModel.createFailResponseModel(
          CONST_LECTURE_CREATE_FAIL_MSG);
    }
  }

  /// TODO 강의 정보 삭제
  Future<void> deleteLecture() async {}

  /// TODO 강의 등록 신청
  Future<ResponseModel> createLectureApply(LectureApplyModel applyModel) async {
    try{
      await applies_ref.add(applyModel.toJson());
      return ResponseModel.createSuccessResponseModel();
    } on FirebaseException catch (fe) {
        print('createLectureApply >> fe : $fe ');
    } catch (e){
        print('createLectureApply >> e : $e ');
    }
    
    return ResponseModel(responseCode: CONST_LECTURE_APPLY_CREATE_FAIL_CODE, responseMsg: CONST_LECTURE_APPLY_CREATE_FAIL_MSG);
  }

  /// TODO 강의 등록 신청 조회
  Future<void> readLectureRegistRequestList() async {}

  /// TODO 강의 등록 신청 상태 변경 (수락, 거절)
  Future<void> updateLectureRegist() async {}

  /// Todo 강의 정보에 학생 추가
  Future<void> updateLectureAddStudent() async {}

  /// 강의 목록 조회 with 검색어
  Future<ResponseModel> readLectureListByGubun(
      String keyword, String gubun) async {
    List<Map<String, dynamic>> lectureList = [];
    try {
      final result = await lecture_ref.where(gubun, isEqualTo: keyword).get();
      if (result.docs.isNotEmpty) {
        for (var info in result.docs) {
          var data = info.data() as Map<String, dynamic>;
          print(info.id);
          data['lectureId'] = info.id;
          data['createDt'] = formatTimestampToDate(data['createDt']);
          data['deadLineDt'] = formatTimestampToDate(data['deadLineDt']);
          data['modifyDt'] = formatTimestampToDate(data['modifyDt']);
          lectureList.add(data);
        }
      }
      return ResponseModel(
          responseCode: CONST_SUCCESS_CODE, responseObj: lectureList);
    } on FirebaseException catch (fe) {
      print('readLecutreListByGubun >> fe : $fe ');
      return ResponseModel(responseCode: CONST_LECTURE_READ_FAIL_MSG);
    } catch (e) {
      print('readLecutreListByGubun >> e : $e ');
      return ResponseModel(
          responseCode: CONST_FIRESTORE_ERROR_CODE,
          responseMsg: CONST_FIRESTORE_ERROR_MSG);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:goodedunote/edu/model/lecture_model.dart';

class LectureInfoPop extends StatefulWidget {
  final LectureModel lectureModel;

  const LectureInfoPop({
    super.key,
    required this.lectureModel,
  });

  @override
  State<LectureInfoPop> createState() => _LectureInfoPopState();
}

// Todo 강의정보 팝업 완성
class _LectureInfoPopState extends State<LectureInfoPop> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.lectureModel.lectureNm),
      content: Column(
        children: [],
      ),
    );
  }
}

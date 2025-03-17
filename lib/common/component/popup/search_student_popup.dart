import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:goodedunote/user/model/student_model.dart';
import 'package:goodedunote/user/provider/student_provider.dart';

class SearchStudentPopup extends ConsumerStatefulWidget {
  const SearchStudentPopup({super.key});

  @override
  ConsumerState<SearchStudentPopup> createState() => _SearchStudentPopupState();
}

class _SearchStudentPopupState extends ConsumerState<SearchStudentPopup> {
  String studentId = '';
  StudentModel? studentModel;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(studentProvider);
    return AlertDialog(
      title: Text('학생 추가'),
      content: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: SearchBar(
                    hintText: '아이디를 입력하세요',
                    overlayColor:
                        const WidgetStatePropertyAll(CONST_COLOR_MAIN),
                    shape: WidgetStateProperty.all(
                      ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    trailing: [
                      IconButton(
                          onPressed: () async {
                            // final result  = await state.searchStudent(studentId);
                            // setState(() {
                            //   studentModel = result;
                            // });
                          },
                          icon: const Icon(Icons.search)),
                    ],
                    onChanged: (val) {
                      setState(() {
                        studentId = val;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: CONST_SIZE_20),
            const DottedLine(
              direction: Axis.horizontal,
            ),
            const SizedBox(height: CONST_SIZE_20),
            _renderSearchResult(studentModel),
          ],
        ),
      ),
    );
  }

  Widget _renderSearchResult(StudentModel? studentModel) {
    if(studentModel != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(studentModel.userNm),
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add_circle_sharp,
                    color: Colors.blue,
                  )),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.more_horiz)),
            ],
          )
        ],
      );
    } else {
      return Row(children: [Text('조회결과 없음')],);
    }
  }
}

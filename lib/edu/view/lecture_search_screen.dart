import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodedunote/common/component/custom_zigzagPainter.dart';
import 'package:goodedunote/common/component/text/custom_search_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:goodedunote/common/const/const_text.dart';
import 'package:goodedunote/common/func/commonFunc.dart';
import 'package:goodedunote/common/func/popupFunc.dart';
import 'package:goodedunote/common/layout/default_layout.dart';
import 'package:goodedunote/edu/enum/edu_enum.dart';
import 'package:goodedunote/edu/func/edu_func.dart';
import 'package:goodedunote/edu/model/lecture_model.dart';
import 'package:goodedunote/edu/provider/lecture_provider.dart';
import 'package:goodedunote/edu/view/lecture_apply_screen.dart';
import 'package:goodedunote/edu/view/lecture_info_pop.dart';
import 'package:goodedunote/user/func/user_func.dart';
import 'package:goodedunote/user/model/teahcer_model.dart';
import 'package:dotted_line/dotted_line.dart';

class LectureSearchScreen extends ConsumerStatefulWidget {
  final TeacherModel? teacher;

  static String get routeName => 'lectureSearch';

  const LectureSearchScreen({
    this.teacher,
    super.key,
  });

  @override
  ConsumerState<LectureSearchScreen> createState() => _LectureSearchScreenState();
}

enum Gubun { MONTH, COUNT }

class _LectureSearchScreenState extends ConsumerState<LectureSearchScreen> {
  late LectureProvider _lectureProvider;
  late TextEditingController _searchController;

  final List<String> searchGubunList = ['강의명', '쌤 아이디'];
  String _selectedSearchGubun = '강의명';

  List<LectureModel> _lectureList = [];

  bool _isLoading = true;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return DefaultLayout(
        title: const Text('강의목록'),
        useDrawer: true,
        useBackBtn: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomSearchBar(
                    gubunController: _searchController,
                    leading: DropdownButton(
                      value: _selectedSearchGubun,
                      items: renderDropdownList(),
                      borderRadius: BorderRadius.circular(CONST_SIZE_16),
                      dropdownColor: CONST_COLOR_WHITE,
                      onChanged: (val) {
                        setState(() {
                          _selectedSearchGubun = val;
                        });
                      },
                    ),
                    tailing: [
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.search)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: CONST_SIZE_16),
            Expanded(
              child: Scrollbar(
                child: ListView.separated(
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: CONST_SIZE_20),
                  shrinkWrap: true,
                  itemCount: _lectureList.length,
                  itemBuilder: (context, index) {
                    var lecture = _lectureList[index];
                    var lectureStatus = isBeforeClosing(lecture);
                    return Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  renderClip(
                                      confirmStudentGubunToString(
                                          lecture.targetParticipant),
                                      getTargetStudentColor(
                                          lecture.targetParticipant)),
                                  // Color.fromRGBO(255, 135, 135, 1.0)
                                  renderClip(lecture.lectureSubject,
                                      const Color.fromRGBO(255, 135, 135, 1.0)),
                                  const SizedBox(width: CONST_SIZE_8),
                                  Text(
                                    _getLectureClosetStatus(lectureStatus),
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.person),
                                  Text(lecture.totalStudents.toString()),
                                  const SizedBox(width: CONST_SIZE_8),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.green,
                                  ),
                                  Text(lecture.lectureRating.toString()),
                                  const SizedBox(width: CONST_SIZE_8),
                                  const Icon(Icons.favorite, color: Colors.red),
                                  Text(lecture.lectureLikes.toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Card(
                          // 강의 요약
                          margin: EdgeInsets.zero,
                          color:
                              getTargetStudentColor(lecture.targetParticipant),
                          elevation: 0.0,
                          borderOnForeground: true,
                          shape: const RoundedRectangleBorder(
                              // 둥근 모서리 모양 조절
                              // side: BorderSide(
                              //   color: Colors.grey,
                              //   width: 1,
                              // ),
                              borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          )),
                          child: Container(
                            decoration: BoxDecoration(
                              color: getTargetStudentColor(
                                  lecture.targetParticipant),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  // 그림자 색상과 투명도 조절
                                  offset: const Offset(5, 5),
                                  // x축으로만 그림자가 생기도록 설정
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              // Row with 2 Column
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  flex: 7,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: CONST_SIZE_8,
                                      bottom: 0,
                                      left: CONST_SIZE_8,
                                      right: CONST_SIZE_8,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: CONST_SIZE_8),
                                        Text(
                                          lecture.lectureNm,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: CONST_TEXT_20,
                                          ),
                                        ),
                                        const SizedBox(height: CONST_SIZE_16),
                                        Text(
                                          lecture.lectureEtc,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: CONST_TEXT_14,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: CONST_SIZE_16),
                                        Row(
                                          children: [
                                            Text(
                                              lecture.lecturePayGubun ==
                                                      LECTURE_PAY_ENUM.MONTH
                                                  ? '주'
                                                  : '회차',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: CONST_TEXT_14,
                                              ),
                                            ),
                                            const SizedBox(width: CONST_SIZE_8),
                                            Text(
                                              '${lecture.lectureCount} 회',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: CONST_TEXT_14,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              lecture.lecturePayGubun ==
                                                      LECTURE_PAY_ENUM.MONTH
                                                  ? '월 등록비'
                                                  : '등록비',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: CONST_TEXT_14,
                                              ),
                                            ),
                                            const SizedBox(width: CONST_SIZE_8),
                                            Text(
                                              '${formatPrice(lecture.lectureCost.toString())} \\',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: CONST_TEXT_14,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: ColoredBox(
                                    color: Colors.white70,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: CONST_SIZE_8),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              if (lectureStatus ==
                                                  LECTURE_CLOSE_STATUS.CLOSED) {
                                                showAlertPopUp(
                                                    context: context,
                                                    content: '신청 마감된 강의입니다.');
                                                return;
                                              }

                                              context.pushNamed(
                                                  LectureApplyScreen.routeName,
                                                  extra: lecture);
                                            },
                                            style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                            ),
                                            child: const Text(
                                              '강의신청',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: CONST_TEXT_14,
                                              ),
                                            ),
                                          ),
                                          const DottedLine(
                                              direction: Axis.horizontal),
                                          TextButton(
                                            onPressed: () {},
                                            child: const Text(
                                              '강의문의',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: CONST_TEXT_14,
                                              ),
                                            ),
                                          ),
                                          const DottedLine(
                                              direction: Axis.horizontal),
                                          TextButton(
                                            onPressed: () {
                                              animationDialog(
                                                  context: context,
                                                  next: LectureInfoPop(
                                                    lectureModel: lecture,
                                                  ));
                                            },
                                            child: const Text(
                                              '강의정보',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: CONST_TEXT_14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Stack renderClip(String content, Color color) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          painter: ZigzagPainter(color: color),
          // Color.fromRGBO(220, 220, 220, 1.0)
          size: const Size(50, 30),
        ),
        Positioned(
          // 텍스트를 아래쪽으로 배치하여 하단의 위젯과 빠작 붙이기
          bottom: 0,
          child: Text(
            content,
          ),
        ),
      ],
    );
  }

  Row renderRow(String content) {
    return Row(
      children: [Text(content)],
    );
  }

  TextButton renderTabButton(String tabName, Color color) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      child: Text(tabName),
      onPressed: () {},
    );
  }

  List<DropdownMenuItem> renderDropdownList() {
    List<DropdownMenuItem> itemList = [];
    for (var gubun in searchGubunList) {
      final item = DropdownMenuItem(
        value: gubun,
        child: Text(gubun),
      );
      itemList.add(item);
    }
    return itemList;
  }

  void _init() {
    _searchController = TextEditingController();
    _lectureProvider = ref.read(lectureProvider);

    if (widget.teacher != null) {
      _initTeacherLecture();
    }

    setState(() {
      _isLoading = false;
    });
  }

  /// 선생의 정보를 갖고 페이지에 진입할 경우, 선생의 강의 목록을 바로 가져옴
  void _initTeacherLecture() async {
    String searchGubun = '쌤 아이디';
    String teacherId = widget.teacher!.userId;
    List<LectureModel> lectureList = [];

    final response =
        await _lectureProvider.getLectureListByKeyword(teacherId, 'teacherId');

    if (response.responseCode == CONST_SUCCESS_CODE) {
      lectureList = response.responseObj as List<LectureModel>;
    }

    setState(() {
      _selectedSearchGubun = searchGubun;
      _searchController.text = teacherId;
      _lectureList = lectureList;
    });
  }

  /// 마감 상태 확인
  String _getLectureClosetStatus(LECTURE_CLOSE_STATUS? lectureStatus) {
    if (lectureStatus != null) {
      if (lectureStatus == LECTURE_CLOSE_STATUS.BEFORE_PARTICIPANTS ||
          lectureStatus == LECTURE_CLOSE_STATUS.BEFORE_DAY) {
        return '마감직전';
      } else {
        return '마감';
      }
    } else {
      return '';
    }
  }
}

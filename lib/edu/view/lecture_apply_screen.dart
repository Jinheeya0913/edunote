import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bottom_picker/bottom_picker.dart' as Bottom;
import 'package:goodedunote/common/component/button/custom_text_button.dart';
import 'package:goodedunote/common/component/custom_checkbox.dart';
import 'package:goodedunote/common/component/text/custom_text_input_field.dart';
import 'package:goodedunote/common/component/user_drawer.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:goodedunote/common/const/const_text.dart';
import 'package:goodedunote/common/func/commonFunc.dart';
import 'package:goodedunote/common/func/datetimeFunc.dart';
import 'package:goodedunote/common/func/widgetFunc.dart';
import 'package:goodedunote/common/layout/default_layout.dart';
import 'package:goodedunote/common/model/fb_result_model.dart';
import 'package:goodedunote/edu/enum/edu_enum.dart';
import 'package:goodedunote/edu/func/edu_func.dart';
import 'package:goodedunote/edu/model/lecture_apply_model.dart';
import 'package:goodedunote/edu/model/lecture_model.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:goodedunote/edu/provider/lecture_apply_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:goodedunote/user/view/student/student_root.dart';

class LectureApplyScreen extends ConsumerStatefulWidget {
  static String get routeName => 'lectureApply';

  final LectureModel lecture;

  const LectureApplyScreen({
    super.key,
    required this.lecture,
  });

  @override
  ConsumerState<LectureApplyScreen> createState() => _LectureApplyScreenState();
}

class _LectureApplyScreenState extends ConsumerState<LectureApplyScreen> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  // controller
  late TextEditingController _levelSelectController;

  Map<String, bool> _dayCheckMap = {
    '상관없음': false,
    '월': false,
    '화': false,
    '수': false,
    '목': false,
    '금': false,
    '토': false,
    '일': false,
  };

  late List<String> _lectureDayStringList;

  // 희망시간대

  bool _startSelected = false;
  bool _endSelected = false;
  bool _noSelectTime = false;

  Time _startTime = Time(hour: 00, minute: 00, second: 00);
  Time _endTime = Time(hour: 00, minute: 00, second: 00);

  // 학습 레벨
  late List<Widget> _lectureLevelList;
  final List<String> _levelStringList = ['초급', '중급', '고급'];
  String _selectedLevel = '';

  // 추천인

  String _recommendUser = '';

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      useBackBtn: true,
      useDrawer: true,
      title: const Text('강의신청'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.lecture.lectureNm,
            style: const TextStyle(fontSize: CONST_TEXT_30),
          ),
          Text(widget.lecture.lectureEtc),
          if (widget.lecture.lectureDayList != null)
            Row(
              children: [
                const Text('수업 가능 요일 : '),
                Text(_lectureDayStringList.join(',')),
              ],
            ),
          const SizedBox(height: CONST_SIZE_16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 희망 수업 요일
                  Column(
                    // 요일 선택
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('상관없음'),
                          CustomCheckbox(
                            value: _dayCheckMap['상관없음']!,
                            onChanged: (val) {
                              setState(() {
                                _toggleDaySelection('상관없음');
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: CONST_SIZE_8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              const Text('월'),
                              CustomCheckbox(
                                value: _dayCheckMap['월']!,
                                onChanged: _lectureDayStringList.contains('월')
                                    ? (val) {
                                        setState(() {
                                          _toggleDaySelection('월');
                                        });
                                      }
                                    : null,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('화'),
                              CustomCheckbox(
                                value: _dayCheckMap['화']!,
                                onChanged: _lectureDayStringList.contains('화')
                                    ? (val) {
                                        setState(() {
                                          _toggleDaySelection('화');
                                        });
                                      }
                                    : null,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('수'),
                              CustomCheckbox(
                                value: _dayCheckMap['수']!,
                                onChanged: _lectureDayStringList.contains('수')
                                    ? (val) {
                                        setState(() {
                                          _toggleDaySelection('수');
                                        });
                                      }
                                    : null,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('목'),
                              CustomCheckbox(
                                value: _dayCheckMap['목']!,
                                onChanged: _lectureDayStringList.contains('목')
                                    ? (val) {
                                        setState(() {
                                          _toggleDaySelection('목');
                                        });
                                      }
                                    : null,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('금'),
                              CustomCheckbox(
                                value: _dayCheckMap['금']!,
                                onChanged: _lectureDayStringList.contains('금')
                                    ? (val) {
                                        setState(() {
                                          _toggleDaySelection('금');
                                        });
                                      }
                                    : null,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('토'),
                              CustomCheckbox(
                                value: _dayCheckMap['토']!,
                                onChanged: _lectureDayStringList.contains('토')
                                    ? (val) {
                                        setState(() {
                                          _toggleDaySelection('토');
                                        });
                                      }
                                    : null,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('일'),
                              CustomCheckbox(
                                value: _dayCheckMap['일']!,
                                onChanged: _lectureDayStringList.contains('일')
                                    ? (val) {
                                        setState(() {
                                          _toggleDaySelection('일');
                                        });
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: CONST_SIZE_16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _subTitle('희망시간대'),
                          Row(
                            children: [
                              const Text('상관없음'),
                              CustomCheckbox(
                                value: _noSelectTime,
                                onChanged: (val) {
                                  setState(() {
                                    _noSelectTime = !_noSelectTime;
                                    if (_noSelectTime) {
                                      _startSelected = false;
                                      _endSelected = false;
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.access_time_outlined),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    showPicker(
                                        showSecondSelector: false,
                                        context: context,
                                        minuteInterval: TimePickerInterval.FIVE,
                                        value: _startTime,
                                        onChange: (val) {
                                          setState(() {
                                            _startSelected = true;
                                            _startTime = val;
                                            _noSelectTime = false;
                                          });
                                        },
                                        onChangeDateTime:
                                            (DateTime dateTime) {
                                          print('dateTime : $dateTime');
                                            }),
                                  );
                                },
                                child: _startSelected
                                    ? Text(
                                        '${_startTime.hour.toString().padLeft(2, '0')} : ${_startTime.minute.toString().padLeft(2, '0')}')
                                    : const Text('강의시작'),
                              ),
                            ],
                          ),
                          const Text("~"),
                          Row(
                            children: [
                              const Icon(Icons.access_time_outlined),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    showPicker(
                                        showSecondSelector: false,
                                        context: context,
                                        minuteInterval: TimePickerInterval.FIVE,
                                        value: _endTime,
                                        onChange: (val) {
                                          setState(() {
                                            _endTime = val;
                                            _endSelected = true;
                                            _noSelectTime = false;
                                          });
                                        },
                                        onChangeDateTime: (DateTime dateTime) {

                                          if (!_startSelected) {
                                            showOverlayNotification(
                                                context, '시작 시간을 먼저 선택해주세요!');
                                            setState(() {
                                              _endSelected = false;
                                            });
                                            return;
                                          } else if (convertTimeToDateTime(
                                                      _startTime)
                                                  .compareTo(dateTime) >=
                                              0) {
                                            showOverlayNotification(context,
                                                '끝 시간은 시작시간보다 이후여야 합니다');
                                            setState(() {
                                              _endSelected = false;
                                            });
                                            return;
                                          }
                                        }),
                                  );
                                },
                                child: _endSelected
                                    ? Text(
                                        '${_endTime.hour.toString().padLeft(2, '0')} : ${_endTime.minute.toString().padLeft(2, '0')}')
                                    : const Text('강의종료'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ), // 희망 시간대
                  const SizedBox(height: CONST_SIZE_16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _subTitle('나의 LEVEL'),
                      CustomTextButton(
                        controller: _levelSelectController,
                        child: '레벨 선택',
                        padding: const EdgeInsets.all(CONST_SIZE_20),
                        onPressed: () => _openLevelPicker(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: CONST_SIZE_16),
                  Column(
                    children: [
                      Row(
                        children: [
                          _subTitle('추천인'),
                        ],
                      ),
                      const SizedBox(height: CONST_SIZE_8),
                      CustomTextInputField(
                        onChanged: (val) {
                          setState(() {
                            _recommendUser = val;
                          });
                        },
                        hintText: '추천인을 입력해주세요',
                        maxLength: 10,
                      ),
                    ],
                  ),
                  const SizedBox(height: CONST_SIZE_16),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_validValues()) {
                      final resultResponse =
                          await sendApplyRequest(widget.lecture);
                      if (resultResponse.responseCode == CONST_SUCCESS_CODE) {
                        print('신청 성공');
                        showAlertPopUp(
                          context: context,
                          title: '강의 신청',
                          content: '성공적으로 신청하였습니다.',
                          onPressed: (){
                            context.goNamed(StudentRootScreen.routeName);
                          },
                        );

                      } else {
                        showAlertPopUp(
                            context: context,
                            content: resultResponse.responseMsg);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: CONST_COLOR_MAIN),
                  child: const Text(
                    '신청',
                    style: TextStyle(color: CONST_COLOR_WHITE),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _init() {
    setState(() {
      _lectureDayStringList = convertLectureDaysToStrings(widget.lecture);
      _lectureLevelList = createTextListWithString(_levelStringList);
      _levelSelectController = TextEditingController();
    });
  }

  /// 날짜 관련 func start

  void _toggleDaySelection(String day) {
    setState(() {
      _dayCheckMap[day] = !_dayCheckMap[day]!;

      if (day == '상관없음' && _dayCheckMap['상관없음']!) {
        _dayCheckMap.updateAll((key, value) => key == '상관없음' ? true : false);
      } else if (_dayCheckMap.values.where((checked) => checked).length == 7) {
        _dayCheckMap['상관없음'] = true;
      } else {
        _dayCheckMap['상관없음'] = false;
      }
    });
  }

  List<LECTURE_DAY> _getSelectedLectureDays() {
    final dayEnumList = <LECTURE_DAY>[];

    _dayCheckMap.forEach((day, isSelected) {
      if (isSelected) {
        switch (day) {
          case '전체':
            dayEnumList.add(LECTURE_DAY.ALL);
            break;
          case '월':
            dayEnumList.add(LECTURE_DAY.MON);
            break;
          case '화':
            dayEnumList.add(LECTURE_DAY.TUE);
            break;
          case '수':
            dayEnumList.add(LECTURE_DAY.WED);
            break;
          case '목':
            dayEnumList.add(LECTURE_DAY.THU);
            break;
          case '금':
            dayEnumList.add(LECTURE_DAY.FRI);
            break;
          case '토':
            dayEnumList.add(LECTURE_DAY.SAT);
            break;
          case '일':
            dayEnumList.add(LECTURE_DAY.SUN);
            break;
        }
      }
    });

    return dayEnumList;
  }

  Text _subTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: CONST_TEXT_20),
    );
  }

  void _openLevelPicker(BuildContext context) {
    Bottom.BottomPicker(
      items: _lectureLevelList,
      pickerTitle: const Text('레벨 선택'),
      onSubmit: (index) {
        setState(() {
          var selectedLevel = _levelStringList[index];
          print(_levelStringList[index]);
          _levelSelectController.text = _levelStringList[index];
          _selectedLevel = _levelStringList[index];
        });
      },
    ).show(context);
  }

  /// 입력값 검증
  bool _validValues() {
    //요일 선택
    if (!_dayCheckMap['상관없음']! &&
        !_dayCheckMap.values.any((isSelected) => isSelected)) {
      showAlertPopUp(context: context, content: '희망요일을 선택해주세요!');
      return false;
    }

    // 시간 선택
    if (!_noSelectTime && (!_startSelected || !_endSelected)) {
      showAlertPopUp(context: context, content: '시간대를 선택해주세요!');
      return false;
    }

    if (_selectedLevel.isEmpty) {
      showAlertPopUp(context: context, content: 'LEVEL을 선택해주세요');
      return false;
    }

    return true;
  }

  /// 강의 신청
  Future<ResponseModel> sendApplyRequest(
    LectureModel lecture,
  ) async {
    final applyInfo = LectureApplyModel(
      lectureId: lecture.lectureId!,
      lectureDayList: _getSelectedLectureDays(),
      lectureLevel: convertLectureLevelToEnum(_selectedLevel),
      timeAleady: _noSelectTime,
      startTime: convertTimeToDateTime(_startTime),
      endTime: convertTimeToDateTime(_endTime),
      lectureRecommend: _recommendUser,
    );

    final sendResult =
        await ref.read(lectureApplyProvider).sendApplyLecture(applyInfo);
    return sendResult;
  }
}

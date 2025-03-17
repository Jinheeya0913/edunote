import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:goodedunote/common/component/button/custom_elevated_button.dart';
import 'package:goodedunote/common/component/button/custom_text_button.dart';
import 'package:goodedunote/common/component/custom_checkbox.dart';
import 'package:goodedunote/common/component/text/custom_text_input_field.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:goodedunote/common/const/const_text.dart';
import 'package:goodedunote/common/func/commonFunc.dart';
import 'package:goodedunote/common/func/datetimeFunc.dart';
import 'package:goodedunote/common/func/widgetFunc.dart';
import 'package:goodedunote/common/layout/default_layout.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:goodedunote/common/model/fb_result_model.dart';
import 'package:goodedunote/edu/enum/edu_enum.dart';
import 'package:goodedunote/edu/model/lecture_model.dart';
import 'package:goodedunote/edu/provider/lecture_provider.dart';
import 'package:goodedunote/user/func/user_func.dart';
import 'package:goodedunote/user/model/teahcer_model.dart';
import 'package:goodedunote/user/provider/teacher_provider.dart';
import 'package:goodedunote/user/provider/user_provider.dart';

class TeacherLectureCreateScreen extends ConsumerStatefulWidget {
  static String get routeName => 'teacherLectureCreate';

  const TeacherLectureCreateScreen({super.key});

  @override
  ConsumerState<TeacherLectureCreateScreen> createState() =>
      _TeacherPlanDetailScreenState();
}

class _TeacherPlanDetailScreenState
    extends ConsumerState<TeacherLectureCreateScreen> {
  late TeacherModel _user;
  late TeacherProvider _teacherProvider;
  late LectureProvider _lectureProvider;

  final _targetParticipants = ['전체', '초등', '중등', '고등'];
  final _lectureSubjects = ['전체', '기타', '수학', '과학', '국어', '영어', '제2외국어'];
  late List<Widget> _subjectItemList;
  late List<Widget> _audienceItemList;

  late ScrollController _scrollController;
  late TextEditingController _countController;
  late TextEditingController _costController;
  late TextEditingController _participantController;
  late TextEditingController _subjectController;
  late TextEditingController _deadLineController;

  String? _selectedParticipant;
  String? _selectedSubject;
  String? lectureName;
  String? lectureEtc;
  String? lectureSubject;
  String? subjectOpt;
  String? curriculum;
  String? lectureCount;
  String? lectureCost;
  int? maxParticipants;
  int? nowParticipants;
  DateTime? deadLineDt;
  LECTURE_PAY_ENUM _lecturePayGubun = LECTURE_PAY_ENUM.MONTH;


  bool _isCheckedDayAll = false;
  bool _isCheckedMon = false;
  bool _isCheckedTue = false;
  bool _isCheckedWed = false;
  bool _isCheckedThu = false;
  bool _isCheckedFri = false;
  bool _isCheckedSat = false;
  bool _isCheckedSun = false;
  int _checkedWeek = 0;

  @override
  void initState() {
    _init();
    super.initState();
  }

  Future<void> _init() async {
    _user = ref.read(userProvider) as TeacherModel;
    _lectureProvider = ref.read(lectureProvider);
    _costController = TextEditingController();
    _countController = TextEditingController();
    _participantController = TextEditingController();
    _subjectController = TextEditingController();
    _deadLineController = TextEditingController();
    _scrollController = ScrollController();
    _subjectItemList = createTextListWithString(_lectureSubjects);
    _audienceItemList = createTextListWithString(_targetParticipants);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: const Text('강의 등록'),
      useDrawer: true,
      useBackBtn: true,
      child: Column(
        children: [
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: CONST_SIZE_16),
                    CustomTextInputField(
                      labelText: !isEmptyString(lectureName)
                          ? '강의명 (${lectureName!.length}/20)'
                          : '강의명',
                      maxLength: 20,
                      inputAction: TextInputAction.next,
                      onChanged: (val) {
                        setState(() {
                          lectureName = val;
                        });
                      },
                    ),
                    const SizedBox(height: CONST_SIZE_16),
                    CustomTextInputField(
                      labelText: !isEmptyString(lectureEtc)
                          ? '강의 소개 (${lectureEtc!.length}/100)'
                          : '강의 소개',
                      maxLines: null,
                      maxLength: 100,
                      onChanged: (val) {
                        setState(() {
                          lectureEtc = val;
                        });
                      },
                    ),
                    const SizedBox(height: CONST_SIZE_16),
                    CustomTextInputField(
                      labelText: '커리큘럼(선택)',
                      maxLines: null,
                      inputAction: TextInputAction.next,
                      onChanged: (val) {
                        setState(() {
                          curriculum = val;
                        });
                      },
                    ),
                    const SizedBox(height: CONST_SIZE_16),
                    CustomTextButton(
                      controller: _participantController,
                      onPressed: () => _openAudiencePicker(context),
                      padding: const EdgeInsets.all(CONST_SIZE_20),
                      child: '학습 대상',
                    ),
                    const SizedBox(height: CONST_SIZE_16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextButton(
                            controller: _subjectController,
                            onPressed: () => _openSubjectPicker(context),
                            padding: const EdgeInsets.all(CONST_SIZE_20),
                            child: '과목',
                          ),
                        ),
                        const SizedBox(width: CONST_SIZE_16),
                        Expanded(
                          child: CustomTextInputField(
                            labelText: '과목 옵션(선택)',
                            hintText: '물리',
                            inputAction: TextInputAction.next,
                            onChanged: (val) {
                              setState(() {
                                subjectOpt = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: CONST_SIZE_16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextButton(
                            controller: _deadLineController,
                            onPressed: () => _openDatePicker(context),
                            padding: const EdgeInsets.all(CONST_SIZE_20),
                            child: '모집마감(선택)',
                          ),
                        ),
                        const SizedBox(width: CONST_SIZE_16),
                        Expanded(
                          child: CustomTextInputField(
                            labelText: '모집인원(선택)',
                            inputAction: TextInputAction.next,
                            digitOnly: true,
                            onChanged: (val) {
                              setState(() {
                                maxParticipants = int.parse(val);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: CONST_SIZE_16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: RadioListTile(
                            value: LECTURE_PAY_ENUM.MONTH,
                            groupValue: _lecturePayGubun,
                            onChanged: (val) {
                              setState(() {
                                _lecturePayGubun = LECTURE_PAY_ENUM.MONTH;
                              });
                            },
                            title: const Text(
                              '월 등록비',
                              style: TextStyle(fontSize: CONST_TEXT_14),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            value: LECTURE_PAY_ENUM.COUNT,
                            groupValue: _lecturePayGubun,
                            onChanged: (val) {
                              setState(() {
                                _lecturePayGubun = LECTURE_PAY_ENUM.COUNT;
                              });
                            },
                            title: const Text(
                              '회차 요금',
                              style: TextStyle(fontSize: CONST_TEXT_14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: CONST_SIZE_16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextInputField(
                            controller : _countController,
                            labelText: _lecturePayGubun == LECTURE_PAY_ENUM.COUNT ? '회차' : '주 수업 회차',
                            inputAction: TextInputAction.next,
                            digitOnly: true,
                            maxLength: 12,
                            onChanged: (val) {
                              if(int.parse(val) < 1  || int.parse(val)>7){
                                _countController.text = '';
                                lectureCount = null;
                                showSimpleAlert(context: context, content: '1 이상 7 이하만 입력 가능합니다');
                                return;
                              }

                              setState(() {
                                lectureCount = val;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: CONST_SIZE_16),
                        Expanded(
                          child: CustomTextInputField(
                            controller: _costController,
                            labelText: _lecturePayGubun == LECTURE_PAY_ENUM.COUNT ? '등록비 \\' : '월 요금 \\' ,
                            inputAction: TextInputAction.next,
                            digitOnly: true,
                            // useController: true,
                            onChanged: (val) {
                              String newVal = val.replaceAll(',', '');
                              String formatVal = formatPrice(newVal);
                    
                              _costController.text =
                                  formatVal; // 필드에 변환 값 기입
                              _costController.selection =
                                  TextSelection.fromPosition(
                                // 커서 위치 조정
                                TextPosition(offset: formatVal.length),
                              );
                    
                              setState(() {
                                setState(() {
                                  lectureCost = formatVal;
                                });
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: CONST_SIZE_16),
                    Column( // 요일 선택
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('수업요일 (선택)'),
                        const SizedBox(height: CONST_SIZE_8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                CustomCheckbox(
                                  value: _isCheckedDayAll,
                                  onChanged: (val) {
                                    setState(() {
                                      _isCheckedDayAll = !_isCheckedDayAll;
                                      if(_isCheckedDayAll){
                                        _initCheckedDay();
                                      }
                                    });
                                  },
                                ),
                                const Text('전체'),
                              ],
                            ),
                            Column(
                              children: [
                                CustomCheckbox(
                                  value: _isCheckedMon,
                                  onChanged: (val) {
                                    setState(() {
                                      _isCheckedMon = !_isCheckedMon;
                                      if(_isCheckedMon){
                                        _checkedWeek += 1;
                                        _isCheckedDayAll = false;
                                      } else {
                                        _checkedWeek -= 1;
                                      }
                                    });
                                  },
                                ),
                                const Text('월'),
                              ],
                            ),
                            Column(
                              children: [
                                CustomCheckbox(
                                  value: _isCheckedTue,
                                  onChanged: (val) {
                                    setState(() {
                                      _isCheckedTue = !_isCheckedTue;
                                      _isCheckedDayAll = false;
                                    });
                                  },
                                ),
                                const Text('화'),
                              ],
                            ),
                            Column(
                              children: [
                                CustomCheckbox(
                                  value: _isCheckedWed,
                                  onChanged: (val) {
                                    setState(() {
                                      _isCheckedWed = !_isCheckedWed;
                                      _isCheckedDayAll = false;
                                    });
                                  },
                                ),
                                const Text('수'),
                              ],
                            ),
                            Column(
                              children: [
                                CustomCheckbox(
                                  value: _isCheckedThu,
                                  onChanged: (val) {
                                    setState(() {
                                      _isCheckedThu = !_isCheckedThu;
                                      _isCheckedDayAll = false;
                                    });
                                  },
                                ),
                                const Text('목'),
                              ],
                            ),
                            Column(
                              children: [
                                CustomCheckbox(
                                  value: _isCheckedFri,
                                  onChanged: (val) {
                                    setState(() {
                                      _isCheckedFri = !_isCheckedFri;
                                      _isCheckedDayAll = false;
                                    });
                                  },
                                ),
                                const Text('금'),
                              ],
                            ),
                            Column(
                              children: [
                                CustomCheckbox(
                                  value: _isCheckedSat,
                                  onChanged: (val) {
                                    setState(() {
                                      _isCheckedSat = !_isCheckedSat;
                                      _isCheckedDayAll = false;
                                    });
                                  },
                                ),
                                const Text('토'),
                              ],
                            ),
                            Column(
                              children: [
                                CustomCheckbox(
                                  value: _isCheckedSun,
                                  onChanged: (val) {
                                    setState(() {
                                      _isCheckedSun = !_isCheckedSun;
                                      _isCheckedDayAll = false;
                                    });
                                  },
                                ),
                                const Text('일'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(CONST_SIZE_8),
                  child: CustomElevatedButton(
                    onPressed: () async {
                      String? validResult = _validInputValues();

                      if (validResult != null) {
                        showSimpleAlert(
                            context: context,
                            title: '등록 실패',
                            content: validResult);
                      } else {
                        final result = await _registLecture();
                        showSimpleAlert(
                            context: context,
                            title: '강의등록',
                            content: result.responseMsg);
                      }
                    },
                    child: const Text(
                      '강의등록',
                      style: TextStyle(
                        color: CONST_COLOR_WHITE,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<ResponseModel> _registLecture() async {
    final lectureModel = LectureModel(
      teacherId: _user.userId,
      lectureNm: lectureName!,
      lectureEtc: lectureEtc!,
      totalStudents: 0,
      lectureSubject: _selectedSubject!,
      subjectOpt: subjectOpt,
      curriculum: curriculum,
      lectureCount: lectureCount!,
      lectureDayList: _getLectureDayList(),
      targetParticipant: confirmStudentGubunToEnum(_selectedParticipant!),
      lecturePayGubun: _lecturePayGubun,
      lectureCost: lectureCost,
      nowParticipants : 0,
      createDt: DateTime.now(),
      deadLineDt: deadLineDt,
      lectureLikes: 0,
      maxParticipants: maxParticipants,
      lectureRating: 0,
    );

    final response = await _lectureProvider.createNewLecture(lectureModel);
    return response;
  }

  void _openDatePicker(BuildContext context) {
    BottomPicker.date(
      pickerTitle: const Text(
        '날짜 선택',
        style: TextStyle(fontSize: CONST_TEXT_14),
      ),
      initialDateTime: DateTime.now(),
      dateOrder: DatePickerDateOrder.ymd,
      bottomPickerTheme: BottomPickerTheme.plumPlate,
      onSubmit: (val) {
        setState(() {
          deadLineDt = val;
          _deadLineController.text = convertDateToString(val as DateTime);
        });
      },
    ).show(context);
  }

  void _openSubjectPicker(BuildContext context) {
    BottomPicker(
      items: _subjectItemList,
      pickerTitle: const Text(
        '과목 선택',
        style: TextStyle(fontSize: CONST_TEXT_14),
      ),
      onSubmit: (index) {
        var selected = _lectureSubjects[index];
        setState(() {
          _subjectController.text = selected;
          _selectedSubject = selected;
        });
      },
    ).show(context);
  }

  void _openAudiencePicker(BuildContext context) {
    BottomPicker(
      items: _audienceItemList,
      pickerTitle: const Text(
        '학생 대상 선택',
        style: TextStyle(fontSize: CONST_TEXT_14),
      ),
      onSubmit: (index) {
        setState(() {
          final target = _targetParticipants[index];
          _participantController.text = target;
          _selectedParticipant = target;
        });
      },
    ).show(context);
  }

  String? _validInputValues() {
    String? errorMsg;
 
    if (isEmptyString(lectureName)) {
      errorMsg = '강의명을 입력해주세요';
    } else if (isEmptyString(lectureEtc)) {
      errorMsg = '강의 소개를 입력해주세요';
    } else if (isEmptyString(_participantController.text)) {
      errorMsg = '학습 대상을 선택해주세요';
    } else if (isEmptyString(_subjectController.text)) {
      errorMsg = '과목을 선택해주세요';
    } else if (isEmptyString(lectureCount)) {
      errorMsg = '회차를 입력해주세요';
    } else if (isEmptyString(lectureCost)) {
      errorMsg = '등록비를 입력해주세요';
    }

    // Todo 임시 null 처리 return errorMsg;
    return null;
  }

  void _initCheckedDay() {
    setState(() {
       _isCheckedMon = false;
       _isCheckedTue = false;
       _isCheckedWed = false;
       _isCheckedThu = false;
       _isCheckedFri = false;
       _isCheckedSat = false;
       _isCheckedSun = false;
    });
  }

  List<LECTURE_DAY>? _getLectureDayList(){
    List<LECTURE_DAY> lectureDayList = [];

    if(_isCheckedDayAll) {
      lectureDayList.add(LECTURE_DAY.ALL);
    } else {
      if (_isCheckedMon) {
        lectureDayList.add(LECTURE_DAY.MON);
      }
      if (_isCheckedTue) {
        lectureDayList.add(LECTURE_DAY.TUE);
      }
      if (_isCheckedWed) {
        lectureDayList.add(LECTURE_DAY.WED);
      }
      if (_isCheckedThu) {
        lectureDayList.add(LECTURE_DAY.THU);
      }
      if (_isCheckedFri) {
        lectureDayList.add(LECTURE_DAY.FRI);
      }
      if (_isCheckedSat) {
        lectureDayList.add(LECTURE_DAY.SAT);
      }
      if (_isCheckedSun) {
        lectureDayList.add(LECTURE_DAY.SUN);
      }
    }

    if(lectureDayList.isEmpty){
      return null;
    }



  }
}

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodedunote/common/component/popup/PopupTitle.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:goodedunote/common/func/commonFunc.dart';
import 'package:goodedunote/common/model/fb_result_model.dart';
import 'package:goodedunote/user/enum/user_enum.dart';
import 'package:goodedunote/user/model/connect_model.dart';
import 'package:goodedunote/user/model/student_model.dart';
import 'package:goodedunote/user/model/teahcer_model.dart';
import 'package:goodedunote/user/provider/student_provider.dart';
import 'package:goodedunote/user/provider/user_provider.dart';
import 'package:goodedunote/user/view/teacher/teacher_simple_info_pop.dart';

class SearchTeacherPopUp extends ConsumerStatefulWidget {
  static String get routeName => 'searchTeacherPop';

  const SearchTeacherPopUp({super.key});

  @override
  ConsumerState<SearchTeacherPopUp> createState() => _SearchTeacherPopUpState();
}

class _SearchTeacherPopUpState extends ConsumerState<SearchTeacherPopUp> {
  String teacherId = '';
  TeacherModel? _teacherModel;
  LINKED_STATUS? _linkedStatus;

  late StudentModel _user;
  late StudentProvider _studentProvider;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: PopupTitle(
        context: context,
        title: Text('티처 추가'),
      ),
      content: Column(
        children: [

        Row(
            children: [
              Expanded(
                child: SearchBar(
                  hintText: '아이디를 입력하세요',
                  overlayColor: const WidgetStatePropertyAll(CONST_COLOR_MAIN),
                  shape: WidgetStateProperty.all(
                    ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  trailing: [
                    IconButton(
                        // 검색 버튼
                        onPressed: () async {
                          await searchTeacherInfo(context);
                        },
                        icon: const Icon(Icons.search)),
                  ],
                  onChanged: (val) {
                    setState(() {
                      teacherId = val;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: CONST_SIZE_20),

          // 버전 업 이후 width 지정 없이 사용하면 layout 오류 발생
          const SizedBox(
            width: 300,
            child: DottedLine(
              direction: Axis.horizontal,
            ),
          ),
          /**/
          const SizedBox(height: CONST_SIZE_20),
          if (_teacherModel != null) _renderSearchResult(),

        ],
      ),
    );
  }

  Future<void> searchTeacherInfo(BuildContext context) async {
    if (!isEmptyString(teacherId)) {
      ResponseModel searchResult =
          await _studentProvider.searchTeacher(_user.userId, teacherId);

      if (searchResult.responseCode == CONST_SUCCESS_CODE) {
        final resultMap = searchResult.responseObj as Map<String, dynamic>;
        final resultTeacher = TeacherModel.fromJson(resultMap['teacherInfo']);
        LINKED_STATUS? linkedStatus;

        if (resultMap['connectInfo'] != null) {
          final connectModel =
              ConnectRequestModel.fromJson(resultMap['connectInfo']);
          linkedStatus = connectModel.linked_status;
        }

        setState(() {
          _teacherModel = resultTeacher;
          _linkedStatus = linkedStatus;
        });
      } else {
        showSimpleAlert(
            context: context, title: '검색결과', content: '검색 결과가 존재하지 않습니다');
        setState(() {
          _teacherModel = null;
          _linkedStatus = null;
        });
      }
    } else {
      showSimpleAlert(context: context, title: '입력오류', content: '검색ID를 입력해주세요');
    }
  }

  Widget _renderSearchResult() {
    if (_teacherModel != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_teacherModel!.userNm),
          Row(
            children: [
              _RenderIconBaseOnLinkedStatus(_user, _teacherModel!),
              IconButton(
                icon: const Icon(Icons.person_search),
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    barrierColor: Colors.black12,
                    pageBuilder: (_, __, ___) => TeacherSimpleInfoPop(
                      teacherModel: _teacherModel!,
                      isConnected: false,
                    ),
                  );
                },
              ),
            ],
          )
        ],
      );
    } else {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text('조회결과 없음')],
      );
    }
  }

  IconButton _RenderIconBaseOnLinkedStatus(
      StudentModel studentModel, TeacherModel teacherModel) {
    final studentState = ref.watch(studentProvider);
    if (_linkedStatus == LINKED_STATUS.linked) {
      return IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.check,
          color: Colors.green,
        ),
      );
    } else if (_linkedStatus == LINKED_STATUS.wait) {
      return IconButton(
        onPressed: () {
          showSimpleAlert(context: context, title: '요청을 취소하시겠습니까?', actions: [
            ElevatedButton(
                onPressed: () async {
                  await _cancelConnectRequest();
                },
                child: Text('예')),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('아니요')),
          ]);
        },
        icon: const Icon(
          Icons.watch_later,
          color: Colors.blue,
        ),
      );
    } else if (_linkedStatus == LINKED_STATUS.refused) {
      return IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.close,
          color: Colors.red,
        ),
      );
    } else {
      return IconButton(
        onPressed: () async {
          ResponseModel requestResult = await sendConnectRequest(
              studentState, teacherModel, studentModel);
          if (requestResult.responseCode != CONST_SUCCESS_CODE) {
            showSimpleAlert(
                context: context,
                title: '요청 실패',
                content: requestResult.responseMsg);
          } else {
            showSimpleAlert(context: context, title: '요청 성공');
            setState(() {
              _linkedStatus = LINKED_STATUS.wait;
            });
          }
        },
        icon: const Icon(
          Icons.add,
          color: Colors.blue,
        ),
      );
    }
  }

  Future<void> _init() async {
    final state = ref.read(studentProvider);
    final user = ref.read(userProvider) as StudentModel;
    setState(() {
      _studentProvider = state;
      _user = user;
    });
  }

  // Todo cancel 기능 구현할 것
  Future<void> _cancelConnectRequest() async {
    ResponseModel responseModel = await _studentProvider.cancelConnectRequest(
        _user.userId, _teacherModel!.userId);

    if (responseModel.responseCode == CONST_SUCCESS_CODE) {
      Navigator.pop(context);
      setState(() {
        _linkedStatus = null;
      });
    } else {
      Navigator.pop(context);
      showSimpleAlert(
          context: context,
          title: '요청 삭제 실패',
          content:
              '${responseModel.responseMsg} : ${responseModel.responseCode}');
    }
  }

  Future<ResponseModel> sendConnectRequest(
    StudentProvider studentState,
    TeacherModel teacherModel,
    StudentModel studentModel,
  ) {
    return studentState.requestConnectToTeacher(
        teacher: teacherModel, student: studentModel);
  }
}

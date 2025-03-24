import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodedunote/common/const/const_icon.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/const/const_text.dart';
import 'package:goodedunote/common/func/commonFunc.dart';
import 'package:goodedunote/user/model/connect_model.dart';
import 'package:goodedunote/user/model/student_model.dart';
import 'package:goodedunote/user/model/teahcer_model.dart';
import 'package:goodedunote/user/model/user_model.dart';
import 'package:goodedunote/user/provider/student_provider.dart';
import 'package:goodedunote/user/provider/user_provider.dart';
import 'package:goodedunote/user/view/student/student_search_teacher_pop.dart';
import 'package:goodedunote/user/view/student/student_teacher_add_que_pop.dart';
import 'package:goodedunote/user/view/teacher/teacher_simple_info_pop.dart';

class TeacherListPopUp extends ConsumerStatefulWidget {
  const TeacherListPopUp({super.key});

  @override
  ConsumerState<TeacherListPopUp> createState() => _TeacherListPopUpState();
}

class _TeacherListPopUpState extends ConsumerState<TeacherListPopUp> {
  List<UserModel>? _teacherList;
  late StudentProvider _studentProvider;
  late StudentModel _user;
  bool _isLoading = true;

  // late StudentModel user;

  @override
  void initState() {
    _init();
    // _setRequestList();
    _setTeacherList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '마이 쌤',
            style: TextStyle(
              fontSize: CONST_TEXT_20,
            ),
          ),
          Row(
            children: [
              // 선생 검색
              IconButton(
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    barrierColor: Colors.black45,
                    pageBuilder: (_, __, ___) => const SearchTeacherSearchPop(),
                  );
                },
                icon: const Icon(Icons.person_search),
              ),
              // 추가 대기열ㅅ
              IconButton(
                onPressed: () {
                  showGeneralDialog(
                    context: context,
                    barrierColor: Colors.black45,
                    pageBuilder: (_, __, ___) => const StudentAddTeacherQuePop(),
                  );
                },
                icon: const Icon(Icons.watch_later),
              ),
              // refresh 버튼 사용 안 함
              /*
              IconButton(
                onPressed: () async {
                  await _refreshUserInfo();
                },
                icon: const Icon(Icons.refresh),
              ),*/
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ],
      ),
      content: SizedBox(
        height: 300,
        child: Column(
          children: [
            //if (_connectRequestList != null) renderRequestList(context),
            renderTeacherList(context),
          ],
        ),
      ),
    );
  }

/*  Widget renderRequestList(BuildContext context) {
    print ('redner RequestList');
    return Column(
      children: [
        const Text('요청 목록'),
        SizedBox(
          height: 300,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: _connectRequestList!.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final connectRequest = _connectRequestList![index];

              final teacherModel =
                  TeacherModel.fromJson(connectRequest.teacherInfo!);

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(teacherModel.userId),
                  Row(
                    children: [
                      // IconButton(
                      //     onPressed: () async  {
                      //     }, icon: CONST_ICON_CHECK),
                      IconButton(
                          onPressed: () async {
                            _cancelConnectRequest(teacherModel);
                          },
                          icon: CONST_ICON_REFUSE),
                    ],
                  )
                ],
              );
            },
          ),
        ),

        if (_connectRequestList!.isNotEmpty)
          const DottedLine(
            direction: Axis.horizontal,
            dashColor: Colors.grey,
          ),
      ],
    );
  }*/

  Widget renderTeacherList(BuildContext context) {
    print('renderTeacherList');
    if (_teacherList != null) {
      return Column(
        children: [
          SizedBox(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _teacherList!.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                final teacherModel = _teacherList![index] as TeacherModel;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${teacherModel.userAlias} 쌤'),
                    Row(
                      children: [
                        IconButton(onPressed: () {}, icon: CONST_ICON_MESSAGE),
                        IconButton(
                            onPressed: () {
                              showGeneralDialog(
                                context: context,
                                barrierColor: Colors.black12,
                                pageBuilder: (_, __, ___) => TeacherSimpleInfoPop(
                                  isConnected: true,
                                  teacherModel: teacherModel,
                                ),
                              );
                            },
                            icon: const Icon(Icons.more_horiz)),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
        ],
      );
    } else {
      return Text('등록된 쌤이 없습니다');
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

  /// 요청 리스트 조회
  /*Future<void> _setRequestList() async {
    final userId = _user.userId;

    print('실행');
    List<ConnectRequestModel> requestList = await _studentProvider
        .confirmAllConnectRequest(userId, _user.user_gubun);
    setState(() {
      _connectRequestList = requestList;
    });
  }*/

  /// 연결된 선생 리스트 조회linked_status
  Future<void> _setTeacherList() async {
    List<ConnectModel>? connectList = _user.connectInfo;

    if (connectList != null) {
      final readListResult =
          await _studentProvider.getAllConnectedList(connectList);

      if (readListResult.responseCode == CONST_SUCCESS_CODE) {
        setState(() {
          _teacherList = readListResult.responseObj as List<TeacherModel>;
          _isLoading = false;
        });
      } else if (readListResult.responseCode == CONST_SUCCESS_NO_RESULT_CODE) {
        setState(() {
          _teacherList = null;
          _isLoading = false;
        });
      } else {
        showSimpleAlert(context: context, content: readListResult.responseMsg);
      }
    } else {
      setState(() {
        _teacherList = null;
        _isLoading = false;
      });
    }
  }
}

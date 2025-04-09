import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:goodedunote/common/const/const_icon.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:goodedunote/common/const/const_text.dart';
import 'package:goodedunote/common/func/popupFunc.dart';
import 'package:goodedunote/common/model/fb_result_model.dart';
import 'package:goodedunote/user/enum/user_enum.dart';
import 'package:goodedunote/user/model/connect_model.dart';
import 'package:goodedunote/user/model/student_model.dart';
import 'package:goodedunote/user/model/teahcer_model.dart';
import 'package:goodedunote/user/provider/teacher_provider.dart';
import 'package:goodedunote/user/provider/user_provider.dart';
import 'package:goodedunote/user/view/student/student_simple_info_pop.dart';

class StudentListPopUp extends ConsumerStatefulWidget {
  const StudentListPopUp({super.key});

  @override
  ConsumerState<StudentListPopUp> createState() => _StudentListPopUpState();
}

class _StudentListPopUpState extends ConsumerState<StudentListPopUp> {
  List<ConnectRequestModel>? _conReqList;
  List<StudentModel>? _studentList;
  late TeacherModel _user;
  late TeacherProvider _teacherProvider;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _init();
    _setRequestList();
    _setStudentList();
  }

  Future<void> _init() async {
    final state = ref.read(teacherProvider);
    final user = ref.read(userProvider) as TeacherModel;

    setState(() {
      _teacherProvider = state;
      _user = user;
    });
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
            '학생 관리',
            style: TextStyle(
              fontSize: CONST_TEXT_20,
            ),
          ),
          Row(
            children: [
              // 학생 검색창
              IconButton(
                onPressed: () {

                },
                icon: const Icon(Icons.person_search),
              ),
              // 요청 대기창
              IconButton(
                onPressed: () {

                },
                icon: const Icon(Icons.timelapse),
              ),
              IconButton(
                onPressed: () {
                  _refreshUserInfo();
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ],
      ),
      content: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // if (_conReqList != null)
            //   if (_conReqList!.isNotEmpty) renderRequestList(context),
            // SizedBox(height: CONST_SIZE_8),
            _studentList != null
                ? renderStudentList()
                : Center(
                    child: Text('학생 없음'),
                  ),
          ],
        ),
      ),
    );
  }

  Widget renderStudentList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Center(child: Text('학생목록')),
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _studentList!.length,
          itemBuilder: (_, index) {
            final studentInfo = _studentList![index];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(studentInfo.userNm),
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: CONST_ICON_MESSAGE),
                    IconButton(
                        onPressed: () {
                          showGeneralDialog(
                              context: context,
                              barrierColor: Colors.black12,
                              pageBuilder: (_, __, ___) => StudentSimpleInfoPop(
                                    studentModel: studentInfo as StudentModel,
                                    isConnected: true,
                                  ));
                        },
                        icon: const Icon(Icons.more_horiz)),
                  ],
                )
              ],
            );
            // return Text('$index');
          },
        ),
      ],
    );
  }

  Column renderRequestList(BuildContext context) {
    return Column(
      children: [
        const Text('요청목록'),
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _conReqList!.length,
          itemBuilder: (_, index) {
            final connectRequest = _conReqList![index];
            final studentModel =
                StudentModel.fromJson(connectRequest.studentInfo!);

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(studentModel.userNm),
                if (connectRequest.linked_status == LINKED_STATUS.wait)
                  _renderWaitRequest(context, _user, studentModel, index),
                // if (connectRequest.linked_status == LINKED_STATUS.refused)
                //   Row(
                //     children: [
                //       IconButton(
                //         icon: Icon(Icons.cancel),
                //         onPressed: () {
                //           _refuseConnectRequest(studentModel.userId);
                //         },
                //       ),
                //     ],
                //   ),
              ],
            );
          },
        ),
        const DottedLine(
          direction: Axis.horizontal,
          dashColor: Colors.grey,
        ),
      ],
    );
  }

  Row _renderWaitRequest(BuildContext context, TeacherModel teacher,
      StudentModel student, int index) {
    return Row(
      children: [
        IconButton(
            onPressed: () async {
              showAlertPopUp(
                context: context,
                content: '요청을 수락 하시겠습니까?',
                onPressed: () async {
                  final result = await _acceptConnectRequest(teacher, student);

                  if (result.responseCode == CONST_SUCCESS_CODE) {
                    Navigator.pop(context);
                    showAlertPopUp(context: context, title: '요청을 수락하였습니다.');
                    setState(() {
                      _conReqList!.removeAt(index);
                    });
                  } else {
                    Navigator.pop(context);
                    showAlertPopUp(
                        context: context,
                        title: '요청에러',
                        content: '다시 시도 바랍니다.');
                  }
                },
              );
            },
            icon: CONST_ICON_CHECK),
        IconButton(
            onPressed: () {
              showAlertPopUp(
                context: context,
                title: '요청을 거절 하시겠습니까?',
                onPressed: () {
                  _refuseConnectRequest(student.userId);
                },
              );
            },
            icon: CONST_ICON_REFUSE),
        IconButton(
          onPressed: () {
            showGeneralDialog(
              context: context,
              barrierColor: Colors.black12,
              pageBuilder: (_, __, ___) => StudentSimpleInfoPop(
                studentModel: student,
                isConnected: false,
              ),
            );
          },
          icon: const Icon(Icons.more_horiz),
        ),
      ],
    );
  }

  Future<void> _setRequestList() async {
    final response = await _teacherProvider.confirmAllConnectRequest(
        _user.userId, _user.user_gubun);

    if (response.responseCode == CONST_SUCCESS_CODE) {
      final requestList = response.responseObj! as List<ConnectRequestModel>?;
      setState(() {
        _conReqList = requestList;
        _isLoading = false;
      });
    } else {
      // showSimpleAlert(context: context, content: response.responseMsg);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _setStudentList() async {
    final List<ConnectModel>? connectList = _user.connectInfo;
    if (connectList != null && connectList.isNotEmpty) {
      print('point1');
      final readResult =
          await _teacherProvider.getAllConnectedStudentList(connectList);
      if (readResult.responseCode == CONST_SUCCESS_CODE) {
        print('point2');
        final studentList = readResult.responseObj as List<StudentModel>;
        setState(() {
          _studentList = studentList;
        });
      }
    } else {
      print('studentList : null');
    }
  }

  Future<void> _refreshUserInfo() async {
    final refreshResult =
        await _teacherProvider.refreshTeacherInfo(_user.userId);
    if (refreshResult.responseCode != CONST_SUCCESS_CODE) {
      showAlertPopUp(context: context, title: refreshResult.responseMsg!);
    } else {
      setState(() {
        _user = refreshResult.responseObj as TeacherModel;
      });
      _setRequestList();
      _setStudentList();
    }
  }

  Future<void> _refuseConnectRequest(String studentId) async {
    final response =
        await _teacherProvider.refuseConnectRequest(_user.userId, studentId);

    if (response.responseCode == CONST_SUCCESS_CODE) {
      showAlertPopUp(context: context, title: '요청을 거절하였습니다.');
    } else {
      showAlertPopUp(context: context, title: '거절 실패', content: '다시 시도 바랍니다.');
    }
  }

  Future<ResponseModel> _acceptConnectRequest(
      TeacherModel teacher, StudentModel student) async {
    ResponseModel response =
        await _teacherProvider.acceptConnectRequest(teacher, student);
    return response;
  }
}

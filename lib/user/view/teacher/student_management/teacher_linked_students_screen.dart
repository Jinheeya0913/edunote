import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/const/const_icon.dart';
import 'package:goodedunote/common/const/const_text.dart';
import 'package:goodedunote/common/layout/default_layout.dart';
import 'package:goodedunote/user/model/connect_model.dart';
import 'package:goodedunote/user/model/student_model.dart';
import 'package:goodedunote/user/model/teahcer_model.dart';
import 'package:goodedunote/user/provider/student_provider.dart';
import 'package:goodedunote/user/provider/teacher_provider.dart';
import 'package:goodedunote/user/provider/user_provider.dart';
import 'package:goodedunote/user/view/student/student_simple_info_pop.dart';

import '../../../../common/const/const_response.dart';
import '../../../../common/const/const_size.dart';

enum LIST_GUBUN { student, request_wait }

class TeacherLinkedStudentScreen extends ConsumerStatefulWidget {
  static String get routeName => 'linkedStudentList';

  const TeacherLinkedStudentScreen({super.key});

  @override
  ConsumerState<TeacherLinkedStudentScreen> createState() =>
      _TeacherLinkedStudentsScreenState();
}

class _TeacherLinkedStudentsScreenState
    extends ConsumerState<TeacherLinkedStudentScreen>
    with SingleTickerProviderStateMixin {
  // Provider
  late TeacherProvider _teacherProvider;

  int index = 0;

  List<ConnectRequestModel>? _conReqList;
  List<StudentModel>? _studentList;
  late TeacherModel _user;

  bool _isLoading = true;


  // speed_dial
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  bool customDialRoot = true;
  bool extend = false;
  bool rmIcons = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    // init
    _initProvider();
    _getStudentList();
    _getRequestList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: Text('학생관리'),
      useBackBtn: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 3,
        openCloseDial: isDialOpen,
        childPadding: EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        children: [
          SpeedDialChild(
            label: '추가',
            labelBackgroundColor: CONST_COLOR_ALL,
            child: !rmIcons ? const Icon(Icons.person_add_alt_1) : null,
            backgroundColor: CONST_COLOR_MAIN,
            onTap: () => setState(()=> rmIcons = !rmIcons),
            onLongPress: ()=> print('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            label: '요청함',
            labelBackgroundColor: CONST_COLOR_ALL,
            child: !rmIcons ? const Icon(Icons.call_made) : null,
            backgroundColor: Colors.green,
            onTap: () => setState(()=> rmIcons = !rmIcons),
            onLongPress: ()=> print('FIRST CHILD LONG PRESS'),
          ),
          SpeedDialChild(
            label: '요청 수신함',
            labelBackgroundColor: CONST_COLOR_ALL,
            child: !rmIcons ? const Icon(Icons.timelapse) : null,
            backgroundColor: Colors.deepOrangeAccent,
            onTap: () => setState(()=> rmIcons = !rmIcons),
            onLongPress: ()=> print('FIRST CHILD LONG PRESS'),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                child: Text('1'),
              ),
            ),
          ),

          /*
          *  _conReqList != null
                    ? _renderReqList(_conReqList!)
                    : const Text('요청 없음'),
                    *
                    * */
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('+')
            ],
          )
        ],
      ),
    );
  }

  // 학생 리스트 그리기
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
                                    studentModel: studentInfo,
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

  Future<void> _initProvider() async {
    final state = ref.read(teacherProvider);
    final user = ref.read(userProvider) as TeacherModel;

    setState(() {
      _teacherProvider = state;
      _user = user;
    });
  }

  /// 연결된 학생 리스트 조회
  Future<void> _getStudentList() async {
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

  /// 연결 요청 조회
  Future<void> _getRequestList() async {
    final response = await _teacherProvider.confirmAllConnectRequest(
        _user.userId, _user.user_gubun);

    print(response.responseCode);

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

  // tem item 그리기
  _tebItem(String title) {
    return Tab(
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  _renderReqList(List<ConnectRequestModel> list) {
    return SingleChildScrollView(
      child: Column(
        children: _conReqList!.map((conRequest) {
          final studentModel = StudentModel.fromJson(conRequest.studentInfo!);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 요청 취소
                Row(
                  children: [
                    const Icon(
                      // Icons.call_received,
                      // Icons.call_made_sharp,
                      Icons.notifications_active,
                      color: Colors.blue,
                    ),
                    Text(studentModel.userAlias),
                  ],
                ),
                Row(
                  children: [
                    // IconButton(
                    //     onPressed: () async  {
                    //     }, icon: CONST_ICON_CHECK),
                    TextButton(
                      onPressed: () async {
                        // _cancelRequestPop(teacherModel);
                      },
                      child: const Text(
                        '요청 취소',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),

        // Center(
        //   child:
        //       Text(_conReqList![0].studentId)
        // ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

import '../../../common/const/const_response.dart';
import '../../../common/const/const_size.dart';

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

  // 상단 리스트 선택 컨트롤러
  late TabController tabController =
      TabController(length: 2, vsync: this, initialIndex: 0);

  int index = 0;

  List<ConnectRequestModel>? _conReqList;
  List<StudentModel>? _studentList;
  late TeacherModel _user;

  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // controller 설정
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(_tabListener);

    // init
    _initProvider();
    _getStudentList();
    _getRequestList();
  }

  @override
  void dispose() {
    // 페이지가 dispose 되면서 리스너 초기화
    tabController.removeListener(_tabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: Text('학생목록'),
      useBackBtn: true,
      child: Column(
        children: [
          // 리스트 출력 선택 탭
          Container(
            // height: 45,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(CONST_BORDER_RADIUS_CIR10),
            ),
            child: TabBar(
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.blue[300],
                borderRadius: BorderRadius.circular(CONST_BORDER_RADIUS_CIR10),
              ),
              tabs: [
                const Tab(
                  child: Text(
                    '학생목록',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '대기 목록',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(
                        width: CONST_SIZE_8,
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: CONST_COLOR_WHITE,
                        ),
                        alignment: Alignment.center,
                        child: _conReqList != null
                            ? Text(
                                _conReqList!.length.toString(),
                                style: const TextStyle(
                                  fontSize: CONST_TEXT_10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            : null,
                      )
                    ],
                  ),
                ),
              ],
              dividerColor: Colors.transparent,

              onTap: (int i) {
                tabController.animateTo(i);
              },
              // labelColor: Colors.black, // 탭 아이템 색상
            ),
          ),
          // content
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                Center(
                  child: Container(
                    child: Text('1'),
                  ),
                ),
                _conReqList != null ? _renderReqList(_conReqList!) : const Text('요청 없음'),

              ],
            ),
          ),
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

  _tabListener() {
    setState(() {
      index = tabController.index;
    });
  }

  _renderReqList(List<ConnectRequestModel> list){
    return SingleChildScrollView(
      child: Column(
        children: [


          // Center(
          //   child:
          //       Text(_conReqList![0].studentId)
          // ),
        ],
      ),
    );

  }
}

import 'package:flutter/material.dart';
import 'package:goodedunote/common/component/popup/PopupTitle.dart';
import 'package:goodedunote/common/const/const_icon.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/func/commonFunc.dart';
import 'package:goodedunote/common/model/fb_result_model.dart';
import 'package:goodedunote/user/model/connect_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodedunote/user/model/student_model.dart';
import 'package:goodedunote/user/model/teahcer_model.dart';
import 'package:goodedunote/user/provider/student_provider.dart';
import 'package:goodedunote/user/provider/user_provider.dart';


class StudentAddTeacherQuePop extends ConsumerStatefulWidget {
  const StudentAddTeacherQuePop({super.key});

  @override
  ConsumerState<StudentAddTeacherQuePop> createState() => _StudentAddTeacherQuePopState();
}

class _StudentAddTeacherQuePopState extends ConsumerState<StudentAddTeacherQuePop> {
  List<ConnectRequestModel>? _connectRequestList;
  late StudentProvider _studentProvider;
  late StudentModel _user;

  @override
  void initState() {
    // TODO: implement initState
    _init();
    _getRequestList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: PopupTitle(title: Text('대기목록'), context: context),
      content: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 300),
        // Todo 고칠 것
        child: renderRequestList(context),
      ),
    );
  }

  // 초기화
  Future<void> _init() async {
    final state = ref.read(studentProvider);
    final user = ref.read(userProvider) as StudentModel;
    setState(() {
      _studentProvider = state;
      _user = user;
    });
  }

  /// 요청 리스트 조회
  Future<void> _getRequestList() async {
    final userId = _user.userId;

    print('실행');
    List<ConnectRequestModel> requestList = await _studentProvider
        .confirmAllConnectRequest(userId, _user.user_gubun);

    setState(() {
      _connectRequestList = requestList;
    });
  }

  /// 요청 리스트 그리기
  Widget renderRequestList(BuildContext context) {
    if (_connectRequestList != null && _connectRequestList!.isNotEmpty) {
      return SingleChildScrollView(
        child: Column(
          children: _connectRequestList!.map((connectRequest) {
            final teacherModel = TeacherModel.fromJson(connectRequest.teacherInfo!);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${teacherModel.userAlias} 쌤'),
                  Row(
                    children: [
                      // IconButton(
                      //     onPressed: () async  {
                      //     }, icon: CONST_ICON_CHECK),
                      IconButton(
                        onPressed: () async {
                          _cancelConnectRequest(teacherModel);
                        },
                        icon: CONST_ICON_REFUSE,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    } else {
      return const Text('요청한 쌤이 없습니다');
    }
  }
  /*Widget renderRequestList(BuildContext context) {
    if (_connectRequestList != null && _connectRequestList!.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: _connectRequestList!.length,
        //physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (_, index) {
          final connectRequest = _connectRequestList![index];
          final teacherModel =
              TeacherModel.fromJson(connectRequest.teacherInfo!);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${teacherModel.userAlias} 쌤'),
              Row(
                children: [
                  // IconButton(
                  //     onPressed: () async  {
                  //     }, icon: CONST_ICON_CHECK),
                  IconButton(
                      onPressed: () async {
                        // Todo 테스트 해보기
                        _cancelConnectRequest(teacherModel);
                      },
                      icon: CONST_ICON_REFUSE),
                ],
              )
            ],
          );
        },
      );
    }else {
      return Text('요청한 쌤이 없습니다');
    }
  }*/

  /// 요청 취소
  _cancelConnectRequest(TeacherModel teacherModel) async {
    showSimpleAlert(
      context: context,
      title: '요청을 취소하시겠습니까?',
      onPressed: () async {
        ResponseModel response = await _studentProvider.cancelConnectRequest(
            _user.userId, teacherModel.userId);
        if (response.responseCode == CONST_SUCCESS_CODE) {
          showSimpleAlert(context: context, title: '요청을 취소하였습니다');
        } else {
          showSimpleAlert(context: context, title: '요청을 실패하였습니다. 다시 시도해주세요.');
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:goodedunote/common/const/const_color.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:goodedunote/common/component/text/custom_text_input_field.dart';
import 'package:goodedunote/common/func/commonFunc.dart';
import 'package:goodedunote/common/layout/default_layout.dart';
import 'package:goodedunote/user/model/student_model.dart';
import 'package:goodedunote/user/model/teahcer_model.dart';
import 'package:goodedunote/user/provider/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:goodedunote/user/enum/user_enum.dart';
import 'package:goodedunote/user/view/student/student_join_screen.dart';
import 'package:goodedunote/user/view/student/student_root.dart';


import 'teacher/teacher_join_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController =
      TabController(length: 3, vsync: this, initialIndex: 0);

  String userId = '';
  String userPw = '';
  USER_GUBUN user_gubun = USER_GUBUN.student;
  String? pwErrorText;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProvider.notifier);

    return DefaultLayout(
      useAppBar: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // SizedBox(
          //   // height: CONST_SIZE_16,
          // ),
          const Row(
            // 제목
            children: [
              Text(
                '에듀노트',
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 50.0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: CONST_SIZE_16, horizontal: CONST_SIZE_16),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                          BorderRadius.circular(CONST_BORDER_RADIUS_CIR10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          // height: 45,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(
                                CONST_BORDER_RADIUS_CIR10),
                          ),
                          child: TabBar(
                            controller: tabController,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              color: Colors.blue[300],
                              borderRadius: BorderRadius.circular(
                                  CONST_BORDER_RADIUS_CIR10),
                            ),
                            tabs: [
                              _tebItem('학생'),
                              _tebItem('학부모'),
                              _tebItem('티처'),
                            ],
                            dividerColor: Colors.transparent,

                            onTap: (int i) {
                              setState(() {
                                if (i == 0) {
                                  user_gubun = USER_GUBUN.student;
                                } else if (i == 1) {
                                  user_gubun = USER_GUBUN.parent;
                                } else if (i == 2) {
                                  user_gubun = USER_GUBUN.teacher;
                                }
                              });
                            },
                            // labelColor: Colors.black, // 탭 아이템 색상
                          ),
                        ),
                        const SizedBox(
                          height: CONST_SIZE_16,
                        ),
                        CustomTextInputField(
                          hintText: '아이디를 입력해주세요',
                          inputAction: TextInputAction.next,
                          style: const TextStyle(fontFamily: 'NotoSansKR-Regular',),
                          onChanged: (val) => userId = val,
                        ),
                        const SizedBox(height: CONST_SIZE_16),
                        CustomTextInputField(
                          inputAction: TextInputAction.done,
                          hintText: '비밀번호를 입력해주세요',
                          hideText: true,
                          // filled: ,
                          style: const TextStyle(fontFamily: 'NotoSansKR-Regular',),
                          onChanged: (val) => userPw = val,
                          errorText: pwErrorText,
                          // onFieldSubmitted: (val) => loginUser(),
                        ),
                      ],
                    ),
                  ), // 고객정보입력칸
                  const SizedBox(height: 50.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          String validMsg = validUserInfo();
                          if (validMsg != '') {
                            showSimpleAlert(
                                context: context,
                                title: '로그인 실패',
                                content: validMsg);
                          } else {

                            var model = await state.login(
                                userId: userId,
                                userPw: userPw,
                                userGubun: user_gubun);

                            if (model is StudentModel) {
                              context.goNamed(StudentRootScreen.routeName);
                            } else if (model is TeacherModel) {
                              // context.goNamed();
                            } else {
                              // Todo 학부모 로그인 구현
                              showSimpleAlert(
                                  context: context,
                                  title: '로그인 실패',
                                  content: '잘못된 계정입니다. 다시 시도해주세요.');
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CONST_COLOR_MAIN,
                          maximumSize: CONST_BTN_MINSIZE,
                        ),
                        child: const Text(
                          '로그인',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: CONST_SIZE_8),
                      ElevatedButton(
                        onPressed: () async {
                          if (user_gubun == USER_GUBUN.teacher) {
                            context.goNamed(TeacherJoinScreen.routeName);
                          } else if (user_gubun == USER_GUBUN.student) {
                            context.goNamed(StudentJoinScreen.routeName);
                          } else {
                            Navigator.of(context).pushNamed(StudentJoinScreen
                                .routeName); // Todo Parent 페이지 넣기
                          }
                        },
                        child: const Text('회원가입'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String validUserInfo() {
    String errorMsg = '';
    if (userId == '') {
      errorMsg = '아이디를 입력해주세요';
    } else if (userPw == '') {
      errorMsg = '비밀번호를 입력해주세요';
    }

    return errorMsg;
  }

/*  kakaoLogin() async {
    UserApi api = UserApi.instance;
    try{
      OAuthToken token =  await api.loginWithKakaoAccount();
      api.me();

    } catch (error){
      print('카카오 계정으로 로그인 실패 : $error');
    }
  }*/

  _tebItem(String title) {
    return Tab(
      child: Text(
        title,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

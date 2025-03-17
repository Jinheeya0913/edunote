import 'package:flutter/material.dart';
import 'package:goodedunote/common/const/const_response.dart';
import 'package:goodedunote/common/const/const_size.dart';
import 'package:goodedunote/common/component/text/custom_text_input_field.dart';
import 'package:goodedunote/common/const/const_text.dart';
import 'package:goodedunote/common/func/commonFunc.dart';
import 'package:goodedunote/common/func/pageMoveFunc.dart';
import 'package:goodedunote/common/layout/default_layout.dart';
import 'package:goodedunote/user/provider/user_provider.dart';
import 'package:goodedunote/user/model/teahcer_model.dart';
import 'package:goodedunote/user/func/user_func.dart';
import 'package:goodedunote/user/enum/user_enum.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeacherJoinScreen extends ConsumerStatefulWidget {
  static String get routeName => 'teacherJoin';
  const TeacherJoinScreen({super.key});

  @override
  ConsumerState<TeacherJoinScreen> createState() => _TeacherJoinScreenState();
}

enum Gubun { INDIVIDUAL, ACADEMY }

class _TeacherJoinScreenState extends ConsumerState<TeacherJoinScreen> {
  Gubun _gubun = Gubun.INDIVIDUAL;

  String userEmail = '';

  String userId = '';

  String userPw = '';

  String userPwConfirm = '';

  String userPhone = '';

  String userNm = '';

  String userAlias = '';

  String? pwError;

  String? pwConfirmError;

  String? academyName;

  String? academyAddress;

  String? academyPresident;

  String? academyTelNumber;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProvider.notifier);

    return DefaultLayout(
      child: Column(
        children: [
          _title(),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CustomTextInputField(
                      onChanged: (value) {
                        userEmail = value;
                      },
                      labelText: '이메일',
                      labelTextStyle: const TextStyle(
                        fontSize: CONST_TEXT_14,
                      ),
                      inputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: CONST_SIZE_20),
                    CustomTextInputField(
                      onChanged: (value) {
                        userId = value;
                      },
                      labelText: 'ID',
                      labelTextStyle: const TextStyle(
                        fontSize: CONST_TEXT_14,
                      ),
                      inputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: CONST_SIZE_20),
                    CustomTextInputField(
                      onChanged: (value) {
                        userPw = value;
                        setState(() {
                          if (userPw.length < 12) {
                            pwError = '비밀번호는 12자리 이상이어야 합니다.';
                          } else {
                            pwError = null;
                          }
                        });
                      },
                      hideText: true,
                      labelText: '비밀번호',
                      labelTextStyle: const TextStyle(fontSize: CONST_TEXT_14),
                      inputAction: TextInputAction.next,
                      errorText: pwError,
                    ),
                    const SizedBox(height: CONST_SIZE_20),
                    CustomTextInputField(
                      onChanged: (value) {
                        userPwConfirm = value;

                        setState(() {
                          if (userPw != userPwConfirm) {
                            pwConfirmError = '일치하지 않는 비밀번호입니다.';
                          } else {
                            pwConfirmError = null;
                          }
                        });
                      },
                      hideText: true,
                      errorText: pwConfirmError,
                      labelText: '비밀번호 재확인',
                      labelTextStyle: const TextStyle(fontSize: CONST_TEXT_14),
                      inputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: CONST_SIZE_20),
                    CustomTextInputField(
                      onChanged: (value) {
                        userAlias = value;
                      },
                      labelText: '닉네임',
                      labelTextStyle: const TextStyle(fontSize: CONST_TEXT_14),
                      inputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: CONST_SIZE_20),
                    CustomTextInputField(
                      onChanged: (value) {
                        userNm = value;
                      },
                      labelText: '이름',
                      labelTextStyle: const TextStyle(fontSize: CONST_TEXT_14),
                      inputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: CONST_SIZE_20),
                    CustomTextInputField(
                      onChanged: (value) {
                        userPhone = value;
                      },
                      labelText: '전화번호',
                      labelTextStyle: const TextStyle(fontSize: CONST_TEXT_14),
                      inputAction: TextInputAction.done,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: RadioListTile(
                            value: Gubun.INDIVIDUAL,
                            groupValue: _gubun,
                            onChanged: (val) {
                              setState(() {
                                _gubun = Gubun.INDIVIDUAL;
                              });
                            },
                            title: Text('개인'),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            value: Gubun.ACADEMY,
                            groupValue: _gubun,
                            onChanged: (val) {
                              setState(() {
                                _gubun = Gubun.ACADEMY;
                              });
                            },
                            title: Text('소속'),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _gubun == Gubun.ACADEMY,
                      child: _academyInfo(),
                    ),
                    const SizedBox(
                      height: CONST_SIZE_20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String? msg = _validUserInfo();

                        if (msg != null) {
                          showSimpleAlert(
                              context: context, title: '회원가입', content: msg);
                        } else {
                          TeacherModel teacherModel = TeacherModel(
                            userEmail: userEmail,
                            userId: userId,
                            userPw: userPw,
                            userNm: userNm,
                            userPhone: userPhone,
                            userAlias: userAlias,
                            user_gubun: USER_GUBUN.teacher,
                            academyAddress: academyAddress,
                            academyName: academyName,
                            academyPresident: academyPresident,
                            academyTelNumber: academyTelNumber,
                          );

                          var result  = await state.join(model: teacherModel);

                          var callbackFunc;

                          if (result.responseCode != CONST_SUCCESS_CODE) {
                            msg = '회원가입에 실패하였습니다. 사유 : ${result.responseMsg}';
                          } else {
                            msg = '회원가입을 축하합니다!';
                            callbackFunc = goToMain();
                          }

                          showSimpleAlert(context: context,
                              title: '회원가입',
                              content: msg,
                              onPressed: callbackFunc);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(140, 60),
                        //fixedSize: Size(240, 80),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ), // 버튼
        ],
      ),
    );
  }

  // 아카데미 정보
  Column _academyInfo() {
    return Column(
      children: [
        const Divider(),
        const SizedBox(height: CONST_SIZE_20),
        CustomTextInputField(
          onChanged: (value) {
            academyName = value;
          },
          labelText: '소속명',
          labelTextStyle: const TextStyle(fontSize: CONST_TEXT_14),
          inputAction: TextInputAction.next,
        ),
        const SizedBox(height: CONST_SIZE_20),
        CustomTextInputField(
          onChanged: (value) {
            academyPresident = value;
          },
          labelText: '대표명',
          labelTextStyle: const TextStyle(fontSize: CONST_TEXT_14),
          inputAction: TextInputAction.next,
        ),
        const SizedBox(height: CONST_SIZE_20),
        CustomTextInputField(
          onChanged: (value) {
            academyAddress = value;
          },
          labelText: '주소',
          labelTextStyle: const TextStyle(fontSize: CONST_TEXT_14),
          inputAction: TextInputAction.next,
        ),
        const SizedBox(height: CONST_SIZE_20),
        CustomTextInputField(

          onChanged: (value) {
            academyTelNumber = value;
          },
          labelText: '연락처',
          labelTextStyle: const TextStyle(fontSize: CONST_TEXT_14),
          inputAction: TextInputAction.done,
        ),
      ],
    );
  }

  _title() {
    return Column(
      children: [
        const Text(
          '선생님 회원가입',
          style:
          TextStyle(fontSize: CONST_TEXT_30, fontWeight: FontWeight.bold),
        ),
        Text(
          '계정을 생성하세요!',
          style: TextStyle(fontSize: CONST_TEXT_14, color: Colors.grey[700]),
        ),
      ],
    );
  }

  /// 1. 기본 입력값 검증
  /// 2. 소속 입력값 검증
  String? _validUserInfo() {
    String? errorMsg = null;

    if (userEmail != '') {
      if (!isEmailFormat(userEmail)) {
        return '이메일 포멧이 아닙니다. 다시 입력해주세요.';
      }
    } else {
      return '이메일을 입력해주세요.';
    }

    if(isEmptyString(userId)){
      return 'ID를 입력해주세요';
    }

    if (userPw != '') {
      if (userPw != userPwConfirm) {
        return '비밀번호와 2차 비밀번호가 일치하지 않습니다.';
      }
    } else {
      return '비밀번호를 입력해주세요.';
    }

    if (userPhone != '') {
      if (!isPhoneNumberFormat(userPhone)) {
        return '전화번호 형식이 아닙니다. 다시 입력해 주세요.';
      }
    } else {
      return '전화번호를 입력하지 않았습니다';
    }

    if (isEmptyString(userNm)) {
      return '성함을 입력해주세요.';
    }

    if (isEmptyString(userAlias)) {
      return '닉네임을 입력해주세요';
    }

    if (_gubun == Gubun.ACADEMY) {
      if (isEmptyString(academyName)) {
        return '소속명을 입력하지 않았습니다';
      } else if (isEmptyString(academyAddress)) {
        return '주소를 입력하지 않았습니다.';
      } else if (isEmptyString(academyPresident)) {
        return '대표명을 입력하지 않았습니다';
      } else if (isEmptyString(academyTelNumber)) {
        return '연락처를 입력하지 않았습니다.';
      }
    }

    return null;
  }

  _kakaoJoinButton() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CONST_BORDER_RADIUS_CIR25),
          border: Border.all(
            color: Colors.yellow.shade700,
          ),
          color: Colors.yellow),
      child: TextButton(
        onPressed: () {},
        child: const Text(
          '카카오톡 계정',
          style: TextStyle(fontSize: CONST_TEXT_20),
        ),
      ),
    );
  }

  _validPhoneNumber() {
    // Todo 휴대전화 인증 로직 추가
  }

}
import 'package:flutter/material.dart';
import 'package:goodedunote/common/component/alert/custom_simple_alert.dart';
import 'package:goodedunote/user/enum/align_enum.dart';


/// 단순 알림창을 표시하는 함수
/// [context]: 화면 컨텍스트
/// [title]: 알림창 제목
/// [content]: 알림창 내용
/// [actions]: 알림창에서 사용할 버튼 리스트
/// [onPressed]: 버튼 클릭 시 실행될 콜백 함수
showAlertPopUp({
  required BuildContext context,
  String? title,
  String? content,
  List<Widget>? actions,
  VoidCallback? onPressed,
  ALIGN_ENUM? content_align,
}) {
  return showDialog(
    context: context,
    builder: (_) => CustomSimpleAlertPop(
      title: title,
      content: content,
      onPressed: onPressed,
      content_align: content_align,
      actions: actions,
    ),
  );
}

/// 문자열이 비어있는지 확인하는 함수
/// [val]: 확인할 문자열 값
/// 리턴: 비어있으면 true, 그렇지 않으면 false
isEmptyString(String? val) {
  if (val == null || val == '') {
    return true;
  } else {
    return false;
  }
}

/// 위젯을 애니메이션으로 표시하는 함수
/// [context]: 화면 컨텍스트
/// [next]: 애니메이션으로 표시할 위젯
void animationDialog({
  required BuildContext context,
  required Widget next,
}) {
  showGeneralDialog(
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    context: context,
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: next);
    },
  );
}



/// 텍스트 메시지를 포함한 스낵바 알림을 표시하는 함수
/// [context]: 화면 컨텍스트
/// [text]: 스낵바에 표시할 메시지
void showSnackBarAlert(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(text),
      ),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating, // 알림이 떠 있는 형식으로 나타남
    ),
  );
}

/// 오버레이 알림을 표시하는 함수
/// [context]: 화면 컨텍스트
/// [message]: 오버레이 알림에 표시할 메시지
void showOverlayNotification(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50.0,
      left: MediaQuery.of(context).size.width * 0.1,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  overlay?.insert(overlayEntry);

  // 일정 시간 후 메시지를 제거
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}

/// 숫자 문자열을 천 단위로 쉼표를 추가하여 반환하는 함수
/// [val]: 포맷팅할 숫자 문자열
/// 리턴: 천 단위로 쉼표가 추가된 문자열
String formatPrice(String val){
  return val.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'), // 숫자가 3의 배수로 뒤에 오는지 확인
          (Match m) => '${m[1]},'
  );
}




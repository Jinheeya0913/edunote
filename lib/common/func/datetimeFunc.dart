import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:intl/intl.dart';

/// TIME -> DATETIME으로 변환
DateTime convertTimeToDateTime(Time time) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, time.hour, time.minute);
}

/// 입력된 날짜와 현재 날짜의 차이를 계산하는 함수
/// [date]: 기준 날짜 (yyyy-MM-dd 형식의 문자열)
/// 리턴: 오늘 날짜와의 일 차이
int calculateDaysDifferenceFromNow(String date) {
  DateTime inputDate = DateTime.parse(date);
  DateTime today = DateTime.now();
  Duration difference = inputDate.difference(today);
  return difference.inDays;
}


/// 현재 날짜를 yyyy-MM-dd 형식의 문자열로 반환하는 함수
String getNow() {
  return DateFormat("yyyy-MM-dd").format(DateTime.now());
}

/// 날짜(DateTime 객체)를 yyyy-MM-dd 형식의 문자열로 변환하는 함수
/// [date]: 변환할 날짜
String convertDateToString (DateTime date){
  return DateFormat('yyyy-MM-dd').format(date);
}
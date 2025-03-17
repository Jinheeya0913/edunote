import 'package:goodedunote/common/func/commonFunc.dart';
import 'package:goodedunote/common/func/datetimeFunc.dart';
import 'package:goodedunote/edu/enum/edu_enum.dart';
import 'package:goodedunote/edu/model/lecture_model.dart';

LECTURE_CLOSE_STATUS? isBeforeClosing(LectureModel lectureModel) {
  // 강의 인원 수 마감 check

  int? maxPart = lectureModel.maxParticipants;

  if (maxPart != null) {
    int nowPart = lectureModel.nowParticipants;
    if (nowPart > 0) {
      double percent = (nowPart / maxPart) / 100;
      if (percent < 0.1) {
        return LECTURE_CLOSE_STATUS.BEFORE_PARTICIPANTS;
      }
    }
  }

  DateTime? deadLineDt = lectureModel.deadLineDt;

  // 마감날짜 확인
  if (deadLineDt != null) {
    String convertedDate = convertDateToString(deadLineDt);
    int diff = calculateDaysDifferenceFromNow(convertedDate);
    if (diff < 0) {
      return LECTURE_CLOSE_STATUS.CLOSED;
    } else if (diff < 7) {
      return LECTURE_CLOSE_STATUS.BEFORE_DAY;
    }
  }

  return null;
}

/// ENUM LIST 강의요일 => STRING LIST
List<String> convertLectureDaysToStrings (LectureModel lecture) {
  final list = lecture.lectureDayList;
  final dayStringList = <String>[];
  if (list != null) {
    for (var day in list) {
      print(day);
      if (day == LECTURE_DAY.ALL) {
        dayStringList.add('전체');
      } else if (day == LECTURE_DAY.MON) {
        dayStringList.add('월');
      } else if (day == LECTURE_DAY.TUE) {
        dayStringList.add('화');
      } else if (day == LECTURE_DAY.WED) {
        dayStringList.add('수');
      } else if (day == LECTURE_DAY.THU) {
        dayStringList.add('목');
      } else if (day == LECTURE_DAY.FRI) {
        dayStringList.add('금');
      } else if (day == LECTURE_DAY.SAT) {
        dayStringList.add('토');
      } else if (day == LECTURE_DAY.SUN) {
        dayStringList.add('일');
      } else if (day == LECTURE_DAY.ALL) {}
    }
  }
  return dayStringList;
}

/// STRING LIST 강의요일 => ENUM LIST
List<LECTURE_DAY> convertLectureDaysToEnums(List<String> dayStrings){
  final dayEnumList = <LECTURE_DAY>[];

  for (var dayString in dayStrings) {
    if (dayString == '전체') {
      dayEnumList.add(LECTURE_DAY.ALL);
    } else if (dayString == '월') {
      dayEnumList.add(LECTURE_DAY.MON);
    } else if (dayString == '화') {
      dayEnumList.add(LECTURE_DAY.TUE);
    } else if (dayString == '수') {
      dayEnumList.add(LECTURE_DAY.WED);
    } else if (dayString == '목') {
      dayEnumList.add(LECTURE_DAY.THU);
    } else if (dayString == '금') {
      dayEnumList.add(LECTURE_DAY.FRI);
    } else if (dayString == '토') {
      dayEnumList.add(LECTURE_DAY.SAT);
    } else if (dayString == '일') {
      dayEnumList.add(LECTURE_DAY.SUN);
    }
  }

  return dayEnumList;
}

/// LECTURE LEVEL STRING -> ENUM
LECTURE_LEVEL convertLectureLevelToEnum (String lectureLevel){
  LECTURE_LEVEL level;
  if(lectureLevel=='고급'){
    level = LECTURE_LEVEL.HIGH;
  } else if (lectureLevel == '중급'){
    level = LECTURE_LEVEL.MIDDLE;
  } else {
    level = LECTURE_LEVEL.LOW;
  }

  return level;
}

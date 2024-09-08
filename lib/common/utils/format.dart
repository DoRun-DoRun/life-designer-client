import 'package:dorun_app_flutter/common/constant/data.dart';
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:intl/intl.dart';

String formattedAlertTime(Duration? time) {
  String formattedTime = '알람 없음';
  if (time == null) return formattedTime;

  if (time.inHours > 0) {
    formattedTime = '${time.inHours}시간 ${time.inMinutes ~/ 60}분 전';
  } else {
    formattedTime = '${time.inMinutes}분 전';
  }
  return formattedTime;
}

String formattedProcessTime(Duration? time) {
  String formattedTime = '';
  if (time == null) return formattedTime;

  if (time.inHours > 0) {
    formattedTime = '${time.inHours}시간 ${time.inMinutes ~/ 60}분';
  } else {
    formattedTime = '${time.inMinutes}분';
  }
  return formattedTime;
}

String mapTextToOverallRating(String text) {
  switch (text) {
    case '힘들어요':
      return 'Difficult';
    case '아쉬워요':
      return 'Disappointing';
    case '만족해요':
      return 'Satisfied';
    case '뿌듯해요':
      return 'Proud';
    default:
      throw Exception('Unknown rating text');
  }
}

List<SubRoutineReviewModel> convertToSubRoutineReviews(
    RoutineHistory routineHistory) {
  return routineHistory.histories.map((history) {
    return SubRoutineReviewModel(
      subRoutineId: history.subRoutine.id,
      timeSpent: history.duration,
      isSkipped: history.state == RoutineHistoryState.passed,
    );
  }).toList();
}

DateTime durationToDateTime(Duration duration) {
  DateTime today = DateTime.now();

  return DateTime(today.year, today.month, today.day, duration.inHours,
      duration.inMinutes % 60);
}

String formatDateTime(Duration duration) {
  final dateTime = durationToDateTime(duration);

  final DateFormat formatter = DateFormat('HH:mm 시작');
  return formatter.format(dateTime);
}

String formatTime(int seconds) {
  bool isNegative = seconds < 0;
  Duration duration = Duration(seconds: seconds.abs());

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  int hours = duration.inHours;
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  String formattedTime = hours > 0
      ? "${twoDigits(hours)}:$twoDigitMinutes:$twoDigitSeconds"
      : "$twoDigitMinutes:$twoDigitSeconds";

  return isNegative ? "-$formattedTime" : formattedTime;
}

String formatTimeRange(int startTimeInSeconds, int durationInSeconds) {
  final startTime =
      DateTime(0, 0, 0).add(Duration(seconds: startTimeInSeconds));

  final endTime = startTime.add(Duration(seconds: durationInSeconds));

  final startFormatted =
      "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}";
  final endFormatted =
      "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}";

  return "$startFormatted ~ $endFormatted";
}

String formatRoutineDays(List<bool> days) {
  if (days.every((day) => !day)) {
    return '반복안함';
  }

  if (days.every((day) => day)) {
    return "매일";
  } else if (days.sublist(1, 6).every((day) => day) && !days[6] && !days[0]) {
    return '평일';
  } else if (!days.sublist(1, 6).contains(true) && days[0] && days[6]) {
    return "주말";
  } else {
    List<String> dayNames = [];
    List<String> dayMapping = ["일", "월", "화", "수", "목", "금", "토"];

    for (int i = 0; i < days.length; i++) {
      if (days[i]) {
        dayNames.add(dayMapping[i]);
      }
    }

    return "커스텀(${dayNames.join(", ")})";
  }
}

RepeatCycle formatRoutineType(List<bool> days) {
  if (days.every((day) => day)) {
    return RepeatCycle.daily;
  } else if (days.sublist(1, 6).every((day) => day) && !days[6] && !days[0]) {
    return RepeatCycle.weekdays;
  } else if (!days.sublist(1, 6).contains(true) && days[0] && days[6]) {
    return RepeatCycle.weekends;
  } else {
    return RepeatCycle.custom;
  }
}

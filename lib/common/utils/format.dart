import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';

String formattedAlertTime(DateTime? time) {
  String formattedTime = '알람 없음';
  if (time == null) return formattedTime;

  if (time.hour > 0) {
    formattedTime = '${time.hour}시간 ${time.minute}분 전';
  } else {
    formattedTime = '${time.minute}분 전';
  }
  return formattedTime;
}

String formattedProcessTime(DateTime? time) {
  String formattedTime = '';
  if (time == null) return formattedTime;

  if (time.hour > 0) {
    formattedTime = '${time.hour}시간 ${time.minute}분';
  } else {
    formattedTime = '${time.minute}분';
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
      isSkipped: history.state == RoutineHistoyState.passed,
    );
  }).toList();
}

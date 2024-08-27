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

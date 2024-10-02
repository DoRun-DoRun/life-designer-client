import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';

import '../constant/data.dart';

class DataUtils {
  static String pathToUrl(String value) {
    return 'http://$ip$value';
  }

  static String plainToBase64(String plain) {
    var stringToBase64 = utf8.fuse(base64);

    String encoded = stringToBase64.encode(plain);

    return encoded;
  }
}

String calculateTotalDuration(RoutineHistory routineHistory) {
  int totalSeconds =
      routineHistory.histories.fold(0, (sum, item) => sum + item.duration);

  int hours = totalSeconds ~/ 3600;
  int minutes = (totalSeconds % 3600) ~/ 60;
  int seconds = totalSeconds % 60;

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  if (hours > 0) {
    return "${twoDigits(hours)}시간 ${twoDigits(minutes)}분 ${twoDigits(seconds)}초";
  } else if (minutes > 0) {
    return "${twoDigits(minutes)}분 ${twoDigits(seconds)}초";
  } else {
    return "${twoDigits(seconds)}초";
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

String processEmail(String email) {
  if (!email.contains('@')) {
    return '게스트 계정';
  }

  if (email.split('@').length > 1 &&
      email.split('@')[1].contains('privaterelay')) {
    return '공개되지 않은 이메일';
  }

  return email;
}

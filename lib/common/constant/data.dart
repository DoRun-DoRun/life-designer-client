// ignore_for_file: constant_identifier_names

import 'dart:io';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

// localhost
const emulatorIp = '10.0.2.2:3000';
const simulatorIp = '127.0.0.1:3000';

final ip = Platform.isIOS ? simulatorIp : emulatorIp;

enum RepeatCycle { daily, weekdays, weekends, custom }

class SubRoutine {
  final int id;
  final String name;
  final String emoji;
  final int duration;

  SubRoutine({
    required this.id,
    required this.name,
    required this.emoji,
    required this.duration,
  });
}

class Routine {
  final int id;
  final int totalDuration;
  final DateTime startTime;
  final String name;
  final List<SubRoutine> subRoutines;

  Routine({
    required this.id,
    required this.totalDuration,
    required this.startTime,
    required this.name,
    required this.subRoutines,
  });
}

final List<Routine> routineMockData = [
  Routine(
    id: 1,
    totalDuration: 60,
    startTime: DateTime.now().subtract(const Duration(hours: 1)),
    name: "Morning Routine",
    subRoutines: [
      SubRoutine(id: 0, name: "Stretching", duration: 10, emoji: "🤸‍♂️"),
      SubRoutine(id: 1, name: "Jogging", duration: 30, emoji: "🏃‍♂️"),
      SubRoutine(id: 2, name: "Swimming", duration: 20, emoji: "🏊‍♂️"),
    ],
  ),
  Routine(
    id: 2,
    totalDuration: 45,
    startTime: DateTime.now().subtract(const Duration(hours: 2)),
    name: "Evening Routine",
    subRoutines: [
      SubRoutine(id: 0, name: "Yoga", duration: 20, emoji: "🧘‍♂️"),
      SubRoutine(id: 1, name: "Cycling", duration: 25, emoji: "🚴‍♂️"),
    ],
  ),
];

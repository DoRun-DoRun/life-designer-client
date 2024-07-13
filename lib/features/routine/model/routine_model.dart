class Routine {
  final int id;
  final int totalDuration;
  final DateTime startTime;
  final bool isFinished;
  final String name;
  final List<SubRoutine> subRoutines;

  Routine({
    required this.id,
    required this.totalDuration,
    required this.startTime,
    required this.isFinished,
    required this.name,
    required this.subRoutines,
  });
}

class SubRoutine {
  final int id;
  final String name;
  final String emoji;
  final int durationSecond;

  SubRoutine({
    required this.id,
    required this.name,
    required this.emoji,
    required this.durationSecond,
  });
}

class RoutineHistory {
  final int id;
  final List<SubRoutineHistory> histories;

  RoutineHistory({
    required this.id,
    required this.histories,
  });
}

enum RoutineHistoyState { passed, complete }

class SubRoutineHistory {
  final int id;
  int durationSecond;
  RoutineHistoyState state;

  SubRoutineHistory({
    required this.id,
    required this.durationSecond,
    required this.state,
  });

  void setDurtaionTime(int durationSecond) {
    this.durationSecond = durationSecond;
  }

  void setRoutineState(RoutineHistoyState state) {
    this.state = state;
  }
}

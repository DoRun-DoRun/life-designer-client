import 'package:json_annotation/json_annotation.dart';

part 'routine_model.g.dart';

@JsonSerializable()
class RoutineModel {
  final int id;
  final DateTime startTime;
  final bool isFinished;
  final String name;

  RoutineModel({
    required this.id,
    required this.startTime,
    required this.isFinished,
    required this.name,
  });
  factory RoutineModel.fromJson(Map<String, dynamic> json) =>
      _$RoutineModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineModelToJson(this);
}

@JsonSerializable()
class DetailRoutineModel {
  final int id;
  final String name;
  final int totalDuration;
  final List<SubRoutineModel> subRoutines;

  DetailRoutineModel({
    required this.totalDuration,
    required this.name,
    required this.subRoutines,
    required this.id,
  });
  factory DetailRoutineModel.fromJson(Map<String, dynamic> json) =>
      _$DetailRoutineModelFromJson(json);

  Map<String, dynamic> toJson() => _$DetailRoutineModelToJson(this);
}

@JsonSerializable()
class SubRoutineModel {
  final int id;
  final String goal;
  final String emoji;
  final int duration;

  SubRoutineModel({
    required this.id,
    required this.goal,
    required this.emoji,
    required this.duration,
  });

  factory SubRoutineModel.fromJson(Map<String, dynamic> json) =>
      _$SubRoutineModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubRoutineModelToJson(this);
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

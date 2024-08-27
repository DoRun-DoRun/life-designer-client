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

enum RoutineHistoyState { passed, complete }

class RoutineHistory {
  final int routineId;
  final List<SubRoutineHistory> histories;

  RoutineHistory({
    required this.histories,
    required this.routineId,
  });

  void setDurtaionTime(int duration, int index) {
    histories[index].duration = duration;
  }

  void setRoutineState(RoutineHistoyState state, int index) {
    histories[index].state = state;
  }
}

class SubRoutineHistory {
  SubRoutineModel subRoutine;
  int duration;
  RoutineHistoyState state;

  SubRoutineHistory({
    required this.subRoutine,
    required this.duration,
    required this.state,
  });
}

@JsonSerializable()
class RoutineReviewModel {
  final int routineId;
  final String overallRating;
  final String? comments;
  final List<SubRoutineReviewModel> subRoutineReviews;

  RoutineReviewModel({
    required this.routineId,
    required this.overallRating,
    this.comments,
    required this.subRoutineReviews,
  });

  factory RoutineReviewModel.fromJson(Map<String, dynamic> json) =>
      _$RoutineReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoutineReviewModelToJson(this);
}

@JsonSerializable()
class SubRoutineReviewModel {
  final int subRoutineId;
  final int timeSpent;
  final bool isSkipped;

  SubRoutineReviewModel({
    required this.subRoutineId,
    required this.timeSpent,
    required this.isSkipped,
  });

  factory SubRoutineReviewModel.fromJson(Map<String, dynamic> json) =>
      _$SubRoutineReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubRoutineReviewModelToJson(this);
}

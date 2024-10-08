import 'package:json_annotation/json_annotation.dart';

part 'calendar_model.g.dart';

@JsonSerializable()
class CalendarModel {
  final List<String> completed;
  final List<String> failed;
  final List<String> passed;

  CalendarModel({
    required this.completed,
    required this.failed,
    required this.passed,
  });

  factory CalendarModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarModelFromJson(json);
  Map<String, dynamic> toJson() => _$CalendarModelToJson(this);
}

@JsonSerializable()
class RoutineCalendarModel {
  final String status;
  final CalendarRoutineReviewModel? routineReview;
  final List<CalendarRoutineModel>? details;
  final int? totalTime;

  RoutineCalendarModel({
    required this.status,
    this.routineReview,
    this.details,
    this.totalTime,
  });

  factory RoutineCalendarModel.fromJson(Map<String, dynamic> json) =>
      _$RoutineCalendarModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoutineCalendarModelToJson(this);
}

@JsonSerializable()
class CalendarRoutineReviewModel {
  final int id;
  final int routineId;
  final int userId;
  final String overallRating;
  final String comments;
  final DateTime createdAt;
  final DateTime updatedAt;

  CalendarRoutineReviewModel({
    required this.id,
    required this.routineId,
    required this.userId,
    required this.overallRating,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CalendarRoutineReviewModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarRoutineReviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarRoutineReviewModelToJson(this);
}

@JsonSerializable()
class CalendarRoutineModel {
  final int id;
  final int routineId;
  final String goal;
  final int duration;
  final String emoji;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final int index;
  final int timeSpent;

  CalendarRoutineModel({
    required this.id,
    required this.routineId,
    required this.goal,
    required this.duration,
    required this.emoji,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.index,
    required this.timeSpent,
  });

  factory CalendarRoutineModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarRoutineModelFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarRoutineModelToJson(this);
}

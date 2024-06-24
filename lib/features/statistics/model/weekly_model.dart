import 'package:json_annotation/json_annotation.dart';

part 'weekly_model.g.dart';

abstract class WeeklyModelBase {}

class UserModelError extends WeeklyModelBase {
  final String message;

  UserModelError({
    required this.message,
  });
}

@JsonSerializable()
class WeeklyModel extends WeeklyModelBase {
  final int longestStreakCount;
  final int totalStreak;
  final int currentStreak;

  final double currentStreakProgress;
  final double pastWeeklyProgress;
  final double currentWeeklyProgress;

  final int sucessRoutine;
  final int failedRoutine;
  final int passedRoutine;

  final String feedBackRoutineId;
  final String feedBackRoutineDetail;
  final String feedBackRoutineTitle;

  WeeklyModel(
    this.longestStreakCount,
    this.totalStreak,
    this.currentStreak,
    this.currentStreakProgress,
    this.pastWeeklyProgress,
    this.currentWeeklyProgress,
    this.sucessRoutine,
    this.failedRoutine,
    this.passedRoutine,
    this.feedBackRoutineId,
    this.feedBackRoutineDetail,
    this.feedBackRoutineTitle,
  );

  factory WeeklyModel.fromJson(Map<String, dynamic> json) =>
      _$WeeklyModelFromJson(json);
}

import 'package:json_annotation/json_annotation.dart';

part 'report_model.g.dart';

@JsonSerializable()
class ReportModel {
  final Current current;
  final Progress progress;
  final MaxFailedRoutine maxFailedRoutineLastWeek;
  final Map<String, String> routineWeeklyReport;

  ReportModel({
    required this.current,
    required this.progress,
    required this.maxFailedRoutineLastWeek,
    required this.routineWeeklyReport,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReportModelToJson(this);
}

@JsonSerializable()
class Current {
  final int completed;
  final int failed;
  final int passed;

  Current({
    required this.completed,
    required this.failed,
    required this.passed,
  });

  factory Current.fromJson(Map<String, dynamic> json) =>
      _$CurrentFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentToJson(this);
}

@JsonSerializable()
class Progress {
  final String twoWeeksAgoProgress;
  final String lastWeekProgresds;
  final String differentInWeeks;

  Progress({
    required this.twoWeeksAgoProgress,
    required this.lastWeekProgresds,
    required this.differentInWeeks,
  });

  factory Progress.fromJson(Map<String, dynamic> json) =>
      _$ProgressFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressToJson(this);
}

@JsonSerializable()
class MaxFailedRoutine {
  final int id;
  final int userId;
  final String goal;
  final int startTime;
  final List<bool> repeatDays;
  final int? notificationTime;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool isDeleted;

  MaxFailedRoutine({
    required this.id,
    required this.userId,
    required this.goal,
    required this.startTime,
    required this.repeatDays,
    this.notificationTime,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isDeleted,
  });

  factory MaxFailedRoutine.fromJson(Map<String, dynamic> json) =>
      _$MaxFailedRoutineFromJson(json);

  Map<String, dynamic> toJson() => _$MaxFailedRoutineToJson(this);
}

@JsonSerializable()
class ReportDetail extends MaxFailedRoutine {
  final Map<String, String> status; // 추가된 필드

  ReportDetail({
    required super.id,
    required super.userId,
    required super.goal,
    required super.startTime,
    required super.repeatDays,
    super.notificationTime,
    required super.createdAt,
    required super.updatedAt,
    super.deletedAt,
    required super.isDeleted,
    required this.status,
  });

  factory ReportDetail.fromJson(Map<String, dynamic> json) =>
      _$ReportDetailFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReportDetailToJson(this);
}

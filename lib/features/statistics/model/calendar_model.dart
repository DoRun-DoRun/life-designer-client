import 'package:json_annotation/json_annotation.dart';

part 'calendar_model.g.dart';

abstract class CalendarModelBase {}

@JsonSerializable()
class CalendarModel extends CalendarModelBase {
  final DateTime date;
  final double dailyProgress;

  final int sucessRoutine;
  final int failedRoutine;
  final int passedRoutine;

  CalendarModel(
    this.date,
    this.dailyProgress,
    this.sucessRoutine,
    this.failedRoutine,
    this.passedRoutine,
  );

  factory CalendarModel.fromJson(Map<String, dynamic> json) =>
      _$CalendarModelFromJson(json);
}

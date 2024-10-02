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

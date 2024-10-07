import 'package:json_annotation/json_annotation.dart';

part 'header_model.g.dart';

@JsonSerializable()
class HeaderModel {
  final int maxStreak;
  final int recentStreak;
  final int totalProcessDays;
  final double? recentPerformanceRate;

  HeaderModel({
    required this.maxStreak,
    required this.recentStreak,
    required this.totalProcessDays,
    this.recentPerformanceRate,
  });

  factory HeaderModel.fromJson(Map<String, dynamic> json) =>
      _$HeaderModelFromJson(json);

  Map<String, dynamic> toJson() => _$HeaderModelToJson(this);
}

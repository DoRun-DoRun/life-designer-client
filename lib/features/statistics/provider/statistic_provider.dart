import 'package:dorun_app_flutter/features/statistics/model/calendar_model.dart';
import 'package:dorun_app_flutter/features/statistics/model/header_model.dart';
import 'package:dorun_app_flutter/features/statistics/model/report_model.dart';
import 'package:dorun_app_flutter/features/statistics/repository/statistics_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportDataProvider = FutureProvider<ReportModel>((ref) {
  return ref.watch(statisticsRepositoryProvider).getReportData();
});

final reportDetailsProvider = FutureProvider<List<ReportDetail>>((ref) {
  return ref.watch(statisticsRepositoryProvider).getReportDetails();
});

final streakProvider =
    FutureProvider.family<HeaderModel, int>((ref, routineId) {
  final repository = ref.watch(statisticsRepositoryProvider);
  return repository.getRoutineStreak(routineId);
});

final statisticsProvider = FutureProvider<HeaderModel>((ref) {
  final repository = ref.watch(statisticsRepositoryProvider);
  return repository.getStatistics();
});

final calendarProvider =
    FutureProvider.family<Map<String, CalendarModel>, CalendarParams>(
        (ref, params) {
  final repository = ref.watch(statisticsRepositoryProvider);

  // routineId가 null이 아니면 getRoutineCalendarData를, null이면 getCalendarData를 호출
  if (params.routineId != null) {
    return repository.getRoutineCalendarData(
        params.routineId!, params.month, params.year);
  } else {
    return repository.getCalendarData(params.month, params.year);
  }
});

// Parameters for provider
class CalendarParams {
  final int? routineId;
  final int month;
  final int year;

  CalendarParams({
    this.routineId,
    required this.month,
    required this.year,
  });
}

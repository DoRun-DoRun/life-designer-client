import 'package:dorun_app_flutter/features/statistics/model/report_model.dart';
import 'package:dorun_app_flutter/features/statistics/repository/statistics_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportDataProvider = FutureProvider<ReportModel>((ref) {
  return ref.watch(statisticsRepositoryProvider).getReportData();
});

final reportDetailsProvider = FutureProvider<List<ReportDetail>>((ref) {
  return ref.watch(statisticsRepositoryProvider).getReportDetails();
});

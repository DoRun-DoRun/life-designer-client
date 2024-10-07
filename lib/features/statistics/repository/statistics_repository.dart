import 'package:dio/dio.dart' hide Headers;
import 'package:dorun_app_flutter/features/statistics/model/calendar_model.dart';
import 'package:dorun_app_flutter/features/statistics/model/header_model.dart';
import 'package:dorun_app_flutter/features/statistics/model/report_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../../../common/constant/data.dart';
import '../../../common/dio/dio.dart';

part 'statistics_repository.g.dart';

final statisticsRepositoryProvider = Provider<StatisticsRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return StatisticsRepository(dio, baseUrl: 'http://$ip/statistics');
  },
);

@RestApi()
abstract class StatisticsRepository {
  factory StatisticsRepository(Dio dio, {String baseUrl}) =
      _StatisticsRepository;

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<HeaderModel> getStatistics();

  @GET('/calendar')
  @Headers({'accessToken': 'true'})
  Future<Map<String, CalendarModel>> getCalendarData(
    @Query('month') int month,
    @Query('year') int year,
  );

  @GET('/report')
  @Headers({'accessToken': 'true'})
  Future<ReportModel> getReportData();

  @GET('/report-details')
  @Headers({'accessToken': 'true'})
  Future<List<ReportDetail>> getReportDetails();

  @GET('/routine/{id}')
  @Headers({'accessToken': 'true'})
  Future<HeaderModel> getRoutineStreak(@Path('id') int routineId);

  @GET('/routine/{id}/calendar')
  @Headers({'accessToken': 'true'})
  Future<Map<String, CalendarModel>> getRoutineCalendarData(
    @Path('id') int routineId,
    @Query('month') int month,
    @Query('year') int year,
  );
}

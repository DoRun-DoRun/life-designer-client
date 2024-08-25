import 'package:dio/dio.dart' hide Headers;
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/retrofit.dart';

import '../../../common/constant/data.dart';
import '../../../common/dio/dio.dart';

part 'routine_repository.g.dart';

final routineRepositoryProvider = Provider<RoutineRepository>(
  (ref) {
    final dio = ref.watch(dioProvider);

    return RoutineRepository(dio, baseUrl: 'http://$ip/routines');
  },
);

@RestApi()
abstract class RoutineRepository {
  factory RoutineRepository(Dio dio, {String baseUrl}) = _RoutineRepository;

  @POST('/')
  @Headers({'accessToken': 'true'})
  Future<RoutineModel> createRoutine({
    @Field('goal') required String goal,
    @Field('startTime') required String startTime,
    @Field('repeatDays') required String repeatDays,
    @Field('notificationTime') String? notificationTime,
  });

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<List<RoutineModel>> getRoutines();

  @GET('/{id}')
  @Headers({'accessToken': 'true'})
  Future<DetailRoutineModel> getRoutineDetail(@Path('id') int id);
}

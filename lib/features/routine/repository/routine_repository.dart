import 'package:dio/dio.dart' hide Headers;
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
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
  Future createRoutine(@Body() CreateRoutineModel createRoutineModel);

  @GET('/')
  @Headers({'accessToken': 'true'})
  Future<List<RoutineModel>> getRoutines();

  @PUT('/')
  @Headers({'accessToken': 'true'})
  Future<RoutineModel> editRoutines(@Body() EditRoutineModel editRoutineModel);

  @GET('/detail/{id}')
  @Headers({'accessToken': 'true'})
  Future<DetailRoutineModel> getRoutineDetail(@Path('id') int id);

  @DELETE('/detail/{id}')
  @Headers({'accessToken': 'true'})
  Future<void> deleteRoutine(@Path('id') int id);

  @POST("/sub_routine")
  @Headers({'accessToken': 'true'})
  Future<void> createSubRoutines(
    @Body() List<SubRoutineRequestModel> subRoutines,
  );

  @PUT("/sub_routine/{id}")
  @Headers({'accessToken': 'true'})
  Future<void> editSubRoutine(
      @Body() SubRoutineRequestModel subRoutine, @Path('id') int id);

  @PUT("/sub_routine/order/{id}")
  @Headers({'accessToken': 'true'})
  Future<void> editSubRoutineOrder(
      @Body() List<SubRoutineOrderModel> subRoutines, @Path('id') int id);

  @DELETE("/sub_routine/{id}")
  @Headers({'accessToken': 'true'})
  Future<void> deleteSubRoutine(@Path('id') int id);

  @POST("/routine/review")
  @Headers({'accessToken': 'true'})
  Future<void> createRoutineReview(@Body() RoutineReviewModel routineReview);
}

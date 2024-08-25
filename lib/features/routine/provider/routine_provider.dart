import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:dorun_app_flutter/features/routine/repository/routine_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routineListProvider = FutureProvider<List<RoutineModel>>((ref) async {
  final routineProvider = ref.read(routineRepositoryProvider);
  return routineProvider.getRoutines();
});

final routineDetailProvider =
    FutureProvider.family<DetailRoutineModel, int>((ref, id) async {
  final routineProvider = ref.read(routineRepositoryProvider);
  return routineProvider.getRoutineDetail(id);
});

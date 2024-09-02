import 'dart:async';

import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:dorun_app_flutter/features/routine/provider/routine_provider.dart';
import 'package:dorun_app_flutter/features/routine/repository/routine_repository.dart';
import 'package:dorun_app_flutter/features/search/model/search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/constant/colors.dart';

class RoutineCreateProgressScreen extends ConsumerStatefulWidget {
  static String get routeName => 'routineCreateProgress';

  final String routineGoal;
  final Duration startTime;
  final List<bool> weekDays;
  final Duration? alertTime;
  final List<SubRoutineTemplate>? subRoutines;

  const RoutineCreateProgressScreen({
    super.key,
    required this.routineGoal,
    required this.startTime,
    required this.weekDays,
    required this.alertTime,
    this.subRoutines,
  });

  @override
  ConsumerState<RoutineCreateProgressScreen> createState() =>
      _RoutineCreateProgressScreenState();
}

class _RoutineCreateProgressScreenState
    extends ConsumerState<RoutineCreateProgressScreen> {
  double progress = 0.0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    createRoutine();
    startProgress();
  }

  void startProgress() {
    timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      double stepIncrement = 1.0 / 100;
      setState(() {
        progress += stepIncrement;
        if (progress >= 1) {
          progress = 1.0;
          timer.cancel();

          context.pushReplacement('/');
        }
      });
    });
  }

  String convertTimeOfDayToString(TimeOfDay timeOfDay) {
    final formattedTime =
        "${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}";
    return formattedTime;
  }

  Future<void> createRoutine() async {
    final routineRepository = ref.read(routineRepositoryProvider);

    try {
      await routineRepository.createRoutine(
        CreateRoutineModel(
          goal: widget.routineGoal,
          startTime: widget.startTime.inSeconds,
          repeatDays: widget.weekDays,
          notificationTime: widget.alertTime?.inSeconds,
          subRoutines: widget.subRoutines,
        ),
      );

      if (!mounted) return;

      ref.invalidate(routineListProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create routine: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GapColumn(
              gap: 72,
              children: [
                const Text(
                  '열심히 최적의\n루틴을 생성하고 있어요',
                  style: AppTextStyles.BOLD_20,
                ),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.BACKGROUND_SUB,
                  valueColor:
                      const AlwaysStoppedAnimation<Color?>(AppColors.BRAND),
                  minHeight: 5,
                ),
                Center(child: Image.asset('asset/images/create-character.png'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

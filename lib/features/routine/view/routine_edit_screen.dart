import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/profile/view/profile_screen.dart';
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:dorun_app_flutter/features/routine/provider/routine_provider.dart';
import 'package:dorun_app_flutter/features/routine/repository/routine_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

Future<RoutineHistory?> _fetchRoutineReview(WidgetRef ref, int id) async {
  final routineRepository = ref.read(routineRepositoryProvider);

  try {
    final routine = await routineRepository.getRoutineDetail(id);

    final histories = routine.subRoutines.map((data) {
      return SubRoutineHistory(
        subRoutine: data,
        duration: 0,
        state: RoutineHistoyState.passed,
      );
    }).toList();

    if (histories.isEmpty) {
      return null;
    }

    return RoutineHistory(
      histories: histories,
      routineId: id,
    );
  } catch (e) {
    print('Failed to fetch routine detail: $e');
    rethrow; // 예외를 다시 던져서 호출자에게 전달
  }
}

class RoutineEditScreen extends ConsumerWidget {
  static String get routeName => 'routineEdit';
  final int id;
  const RoutineEditScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, ref) {
    final routineRepository = ref.read(routineRepositoryProvider);

    return DefaultLayout(
      title: '수정하기',
      child: GapColumn(
        gap: 16,
        children: [
          const PaddingContainer(
            width: double.infinity,
            child: Text('운동하기', style: AppTextStyles.BOLD_20),
          ),
          const PaddingContainer(
            child: GapColumn(
              gap: 16,
              children: [
                SystemSettingListItem(
                    title: '알림', textStyle: AppTextStyles.BOLD_20),
                ListItem(routineId: 0, title: '시간', subTitle: ''),
                ListItem(routineId: 0, title: '주기', subTitle: '')
              ],
            ),
          ),
          PaddingContainer(
            child: CustomButton(
              onPressed: () async {
                final routineHistory = await _fetchRoutineReview(ref, id);

                if (routineHistory == null) {
                  context.push('/routine_detail/$id');
                  return;
                }

                context.push(
                  '/routine_review/$id',
                  extra: routineHistory,
                );
              },
              title: '루틴 쉬어가기',
            ),
          ),
          PaddingContainer(
            child: CustomButton(
              onPressed: () {
                try {
                  routineRepository.deleteRoutine(id);
                  context.go('/');
                  ref.invalidate(routineListProvider);
                } catch (e) {
                  print('Failed to create routine: $e');
                }
              },
              title: '루틴 삭제하기',
            ),
          ),
        ],
      ),
    );
  }
}

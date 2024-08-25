import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/routine/provider/routine_provider.dart';
import 'package:dorun_app_flutter/features/routine/view/routine_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class RoutineScreen extends ConsumerWidget {
  static String get routeName => 'routine';

  const RoutineScreen({super.key});

  String _formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('HH:mm 시작');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context, ref) {
    final routineListAsyncValue = ref.watch(routineListProvider);

    return DefaultLayout(
      rightIcon: IconButton(
        icon: const Icon(
          Icons.notifications,
          size: 30,
          color: AppColors.TEXT_SUB,
        ),
        onPressed: () {
          // 알림 버튼 클릭 이벤트 처리
        },
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.BRAND,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const RoutineCreateScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      child: GapColumn(
        gap: 16,
        children: [
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 24, right: 24),
              child: GapColumn(
                gap: 16,
                children: [
                  const DateSelector(),
                  const SizedBox(height: 8),
                  const Text('오늘의 루틴입니다', style: AppTextStyles.BOLD_20),
                  const Text('이제 시작이네요!', style: AppTextStyles.MEDIUM_14),
                  LinearProgressIndicator(
                    value: 0.1, // 진행 상태 값
                    backgroundColor: Colors.grey[300],
                    minHeight: 8,
                    borderRadius: AppRadius.ROUNDED_8,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: routineListAsyncValue.when(
                  data: (routines) {
                    if (routines.isEmpty) {
                      return const Text("루틴을 생성해주세요");
                    }
                    return GapColumn(
                      gap: AppSpacing.SPACE_16,
                      children: routines.map((routine) {
                        return ListItem(
                            id: routine.id,
                            title: routine.name,
                            subTitle: _formatDateTime(routine.startTime),
                            isButton: !routine.isFinished,
                            isDone: routine.isFinished,
                            onTap: () {
                              context.push('/routine_detail/${routine.id}');
                            });
                      }).toList(),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) =>
                      const Center(child: Text('Failed to load routines')),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DateSelector extends StatelessWidget {
  String getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('M월 dd일');
    return formatter.format(now);
  }

  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.5),
      child: GapRow(
        gap: 8,
        children: [
          Text(getFormattedDate(), style: AppTextStyles.MEDIUM_20),
          const Icon(Icons.keyboard_arrow_down, size: 30),
        ],
      ),
    );
  }
}

import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:dorun_app_flutter/features/routine/provider/routine_provider.dart';
import 'package:dorun_app_flutter/features/routine/repository/routine_repository.dart';
import 'package:dorun_app_flutter/features/search/model/search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TemplateDetailAddScreen extends ConsumerStatefulWidget {
  static String get routeName => 'templateDetailAdd';

  final RoutineTemplate routine;
  final SubRoutineTemplate selectedRoutine;

  const TemplateDetailAddScreen(
      {super.key, required this.routine, required this.selectedRoutine});

  @override
  ConsumerState<TemplateDetailAddScreen> createState() =>
      _TemplateDetailAddScreenState();
}

class _TemplateDetailAddScreenState
    extends ConsumerState<TemplateDetailAddScreen> {
  List<SubRoutineTemplate> selectedSubRoutines = [];
  RoutineModel? selectedRoutine;

  @override
  void initState() {
    selectedSubRoutines.add(widget.selectedRoutine);
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAndShowRoutineSelectionSheet();
    });
  }

  Future<void> _fetchAndShowRoutineSelectionSheet() async {
    final routineList = ref.read(routineListProvider);

    await Future.delayed(const Duration(milliseconds: 300));

    routineList.when(
      data: (routines) {
        showRoutineSelectionSheet(routineList);
      },
      loading: () {},
      error: (error, stack) {},
    );
  }

  void toggleSubRoutine(SubRoutineTemplate subRoutine) {
    setState(() {
      if (selectedSubRoutines.contains(subRoutine)) {
        selectedSubRoutines.remove(subRoutine);
      } else {
        selectedSubRoutines.add(subRoutine);
      }
    });
  }

  void showRoutineSelectionSheet(
    AsyncValue<List<RoutineModel>> routineList,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('루틴을 선택해주세요.', style: AppTextStyles.BOLD_20),
              const SizedBox(height: 36),
              routineList.when(
                data: (routines) {
                  if (routines.isEmpty) {
                    return const Center(
                      child: Text(
                        '루틴이 없습니다. 루틴을 추가해 주세요.',
                        style: AppTextStyles.MEDIUM_16,
                      ),
                    );
                  }

                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: routines.map((routine) {
                          final isSelected = routine == selectedRoutine;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedRoutine = routine;
                              });
                              context.pop();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16.0),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.BRAND_SUB
                                    : AppColors.BACKGROUND_SUB,
                                borderRadius: AppRadius.ROUNDED_16,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(
                                child: Text(
                                  routine.name,
                                  style: AppTextStyles.MEDIUM_16.copyWith(
                                    color: isSelected
                                        ? AppColors.BRAND
                                        : AppColors.TEXT_SECONDARY,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) =>
                    Center(child: Text('Error: $error')), // 에러 메시지 표시
              ),
            ],
          ),
        );
      },
    );
  }

  bool get isSelectionValid {
    return selectedRoutine != null && selectedSubRoutines.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final routineList = ref.watch(routineListProvider);
    final routineRepository = ref.read(routineRepositoryProvider);

    return routineList.when(
      data: (routines) {
        return DefaultLayout(
          title: '개별 추가',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: GapColumn(
                    gap: 16,
                    children: [
                      PaddingContainer(
                        width: double.infinity,
                        child: GapColumn(
                          children: [
                            const Text("어느 루틴에 추가할까요?",
                                style: AppTextStyles.BOLD_20),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () {
                                showRoutineSelectionSheet(routineList);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedRoutine != null
                                          ? selectedRoutine!.name
                                          : '루틴을 선택해주세요.',
                                      style: AppTextStyles.MEDIUM_20.copyWith(
                                        color: selectedRoutine != null
                                            ? Colors.black
                                            : Colors.red,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 30,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      PaddingContainer(
                        child: GapColumn(
                          gap: 16,
                          children: [
                            const Text("추가할 세부 루틴을 선택해주세요",
                                style: AppTextStyles.BOLD_20),
                            ...widget.routine.subRoutines.map(
                              (subRoutine) => ListItem(
                                routineId: 0,
                                title: subRoutine.goal,
                                subTitle:
                                    '${(subRoutine.duration ~/ 60).toString()}분',
                                routinEmoji: subRoutine.emoji,
                                actionIcon: Icons.check,
                                actionIconColor:
                                    selectedSubRoutines.contains(subRoutine)
                                        ? AppColors.BRAND
                                        : AppColors.TEXT_INVERT,
                                onTap: () => toggleSubRoutine(subRoutine),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              PaddingContainer(
                child: CustomButton(
                  onPressed: () async {
                    try {
                      if (!isSelectionValid) return;

                      await routineRepository.createSubRoutines(
                        selectedSubRoutines.map((template) {
                          return SubRoutineRequestModel(
                            routineId: selectedRoutine!.id,
                            goal: template.goal,
                            emoji: template.emoji,
                            duration: template.duration,
                          );
                        }).toList(),
                      );
                      ref.invalidate(routineDetailProvider);
                      if (context.mounted) context.go('/');
                    } catch (e) {
                      print('Failed to create routine: $e');
                    }
                  },
                  title: selectedRoutine == null
                      ? "어느 루틴에 추가할지 선택해주세요"
                      : selectedSubRoutines.isEmpty
                          ? '추가할 세부루틴을 선택해주세요'
                          : "세부 루틴 추가히기",
                  backgroundColor: !isSelectionValid
                      ? AppColors.TEXT_INVERT
                      : AppColors.BRAND,
                  foregroundColor: !isSelectionValid
                      ? AppColors.TEXT_SECONDARY
                      : Colors.white,
                ),
              )
            ],
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}

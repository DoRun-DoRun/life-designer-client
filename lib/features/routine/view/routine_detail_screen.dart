import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/input_box.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/common/utils/format.dart';
import 'package:dorun_app_flutter/features/routine/model/routine_model.dart';
import 'package:dorun_app_flutter/features/routine/provider/routine_provider.dart';
import 'package:dorun_app_flutter/features/routine/repository/routine_repository.dart';
import 'package:dorun_app_flutter/features/routine/view/components/set_alert_time.dart';
import 'package:emoji_selector/emoji_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RoutineDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'routineDetail';
  final int id;
  const RoutineDetailScreen({super.key, required this.id});

  @override
  ConsumerState<RoutineDetailScreen> createState() =>
      _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends ConsumerState<RoutineDetailScreen> {
  String _emoji = '✅';

  void _showAddRoutineModal(BuildContext context, SubRoutineModel? subRoutine) {
    Duration? durationTime =
        subRoutine != null ? Duration(seconds: subRoutine.duration) : null;

    final TextEditingController titleController =
        TextEditingController(text: subRoutine?.goal);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (context, setState) {
            bool isFormValid =
                durationTime != null && titleController.text.trim().isNotEmpty;

            titleController.addListener(() {
              setState(() {
                isFormValid = durationTime != null &&
                    titleController.text.trim().isNotEmpty;
              });
            });

            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                    color: Colors.white, borderRadius: AppRadius.ROUNDED_16),
                child: GapColumn(
                  gap: 16,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("루틴을 어떻게 수행하고 있는지 작성해주세요",
                        style: AppTextStyles.MEDIUM_16),
                    GestureDetector(
                      onTap: () {
                        setEmoji(bc, setState);
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: const BoxDecoration(
                              borderRadius: AppRadius.FULL,
                              color: AppColors.BACKGROUND_SUB,
                            ),
                            child: Center(
                              child: Text(
                                _emoji,
                                style:
                                    AppTextStyles.EMOJI.copyWith(fontSize: 30),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "아이콘 변경하기",
                            style: AppTextStyles.MEDIUM_12
                                .copyWith(color: AppColors.TEXT_SUB),
                          )
                        ],
                      ),
                    ),
                    InputBox(controller: titleController, hintText: '세부 루틴'),
                    ReadOnlyBox(
                      hintText: '수행 시간',
                      inputText: formattedProcessTime(durationTime),
                      onTap: () async {
                        durationTime = await setProcessTime(
                          context: context,
                          initialTime: durationTime,
                        );
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    GapRow(
                      gap: 16,
                      children: [
                        if (subRoutine != null)
                          Expanded(
                            child: CustomButton(
                              onPressed: () async {
                                final routineRepository =
                                    ref.read(routineRepositoryProvider);

                                try {
                                  await routineRepository
                                      .deleteSubRoutine(subRoutine.id);
                                  durationTime = null;
                                  ref.invalidate(routineDetailProvider);
                                  bc.pop();
                                } catch (e) {
                                  print('Failed to create routine: $e');
                                }
                              },
                              title: '삭제하기',
                              backgroundColor: AppColors.BRAND_SUB,
                              foregroundColor: AppColors.TEXT_BRAND,
                            ),
                          ),
                        Expanded(
                          child: CustomButton(
                            onPressed: () async {
                              final routineRepository =
                                  ref.read(routineRepositoryProvider);

                              if (!isFormValid) return;

                              try {
                                subRoutine != null
                                    ? await routineRepository.editSubRoutine(
                                        SubRoutineRequestModel(
                                          routineId: widget.id,
                                          goal: titleController.text.trim(),
                                          emoji: _emoji,
                                          duration: durationTime!.inSeconds,
                                        ),
                                        subRoutine.id,
                                      )
                                    : await routineRepository
                                        .createSubRoutines([
                                        SubRoutineRequestModel(
                                          routineId: widget.id,
                                          goal: titleController.text.trim(),
                                          emoji: _emoji,
                                          duration: durationTime!.inSeconds,
                                        )
                                      ]);

                                ref.invalidate(routineDetailProvider);

                                durationTime = null;
                                bc.pop();
                              } catch (e) {
                                print('Failed to create routine: $e');
                              }
                            },
                            title: subRoutine != null ? '수정하기' : '추가하기',
                            backgroundColor: isFormValid
                                ? AppColors.BRAND
                                : AppColors.TEXT_INVERT,
                            foregroundColor: isFormValid
                                ? Colors.white
                                : AppColors.TEXT_SECONDARY,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  void setEmoji(BuildContext context, StateSetter setState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext subcontext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: EmojiSelector(
                onSelected: (emoji) {
                  setState(() {
                    _emoji = emoji.char;
                  });
                  Navigator.of(subcontext).pop(emoji);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final routineDetailAsyncValue = ref.watch(routineDetailProvider(widget.id));
    return routineDetailAsyncValue.when(
      data: (routine) {
        final totalDurtation = Duration(seconds: routine.totalDuration);

        return DefaultLayout(
          rightIcon: IconButton(
            onPressed: () {
              context.push('/routine_edit', extra: routine);
            },
            icon: const Icon(Icons.edit),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GapColumn(
                  gap: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PaddingContainer(
                      width: double.infinity,
                      child: GapColumn(
                        gap: 24,
                        children: [
                          Text(routine.name, style: AppTextStyles.BOLD_20),
                          GapColumn(
                            gap: 8,
                            children: [
                              Text(
                                "총 소요시간",
                                style: AppTextStyles.MEDIUM_14.copyWith(
                                  color: AppColors.TEXT_SUB,
                                ),
                              ),
                              Text(
                                "${totalDurtation.inMinutes} 분",
                                style: AppTextStyles.MEDIUM_20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (routine.subRoutines.isNotEmpty)
                      Expanded(
                        child: PaddingContainer(
                          child: ReorderableListView.builder(
                            onReorder: (oldIndex, newIndex) async {
                              final routineRepository =
                                  ref.read(routineRepositoryProvider);

                              setState(() {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }

                                final subRoutine =
                                    routine.subRoutines.removeAt(oldIndex);
                                routine.subRoutines
                                    .insert(newIndex, subRoutine);

                                for (int i = 0;
                                    i < routine.subRoutines.length;
                                    i++) {
                                  routine.subRoutines[i] =
                                      routine.subRoutines[i].copyWith(index: i);
                                }
                              });

                              await routineRepository.editSubRoutineOrder(
                                routine.subRoutines
                                    .map((subRoutine) => SubRoutineOrderModel(
                                          id: subRoutine.id,
                                          index: subRoutine.index,
                                        ))
                                    .toList(),
                                widget.id,
                              );
                            },
                            itemCount: routine.subRoutines.length,
                            itemBuilder: (context, index) {
                              final data = routine.subRoutines[index];
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: AppRadius.ROUNDED_16,
                                ),
                                key: ValueKey(data.id),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: ListItem(
                                  onTap: () {
                                    setState(() {
                                      _emoji = data.emoji;
                                    });
                                    _showAddRoutineModal(context, data);
                                  },
                                  routineId: data.routineId,
                                  title: data.goal,
                                  routinEmoji: data.emoji,
                                  subTitle: '${data.duration ~/ 60}분',
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    PaddingContainer(
                      child: GapColumn(
                        gap: 16,
                        children: [
                          const Text(
                            "루틴을 수행하고 있는지 작성해주세요",
                            style: AppTextStyles.MEDIUM_16,
                          ),
                          CustomButton(
                            onPressed: () =>
                                _showAddRoutineModal(context, null),
                            icon: const Icon(
                              Icons.add_circle,
                              size: 25,
                              color: AppColors.TEXT_BRAND,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              PaddingContainer(
                child: CustomButton(
                  title: routine.subRoutines.isNotEmpty
                      ? '수행하기'
                      : '세부 루틴을 추가해주세요.',
                  backgroundColor: routine.subRoutines.isNotEmpty
                      ? AppColors.BRAND
                      : AppColors.BACKGROUND_SUB,
                  foregroundColor: routine.subRoutines.isNotEmpty
                      ? AppColors.BRAND_SUB
                      : AppColors.TEXT_SUB,
                  onPressed: () {
                    if (routine.subRoutines.isNotEmpty) {
                      context.go('/routine_proceed/${widget.id}');
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Failed to load routine details $error'),
      ),
    );
  }
}

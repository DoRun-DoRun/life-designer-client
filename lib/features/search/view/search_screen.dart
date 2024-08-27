import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/routine/view/routine_create_screen.dart';
import 'package:dorun_app_flutter/features/search/model/search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String selectedTemplate = '전체';

  void toggleTemplate(String template) {
    setState(() {
      selectedTemplate = template;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<RoutineTemplate> routinesToShow = selectedTemplate == "전체"
        ? templateListRoutine.values.expand((list) => list).toList()
        : templateListRoutine[selectedTemplate] ?? [];

    return DefaultTabController(
      length: 2,
      child: DefaultLayout(
        customAppBar: AppBar(
          title: const Text('둘러보기', style: AppTextStyles.MEDIUM_16),
          backgroundColor: Colors.white,
          bottom: const TabBar(
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 4, color: AppColors.BRAND),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.TEXT_BRAND,
              unselectedLabelColor: AppColors.TEXT_SUB,
              labelStyle: AppTextStyles.BOLD_14,
              unselectedLabelStyle: AppTextStyles.REGULAR_14,
              tabs: [
                Tab(text: "주제별 템플릿"),
                Tab(text: "커뮤니티"),
              ]),
        ),
        child: TabBarView(
          children: [
            GapColumn(
              gap: 16,
              children: [
                Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: PaddingContainer(
                      child: GapRow(
                        gap: 10,
                        children: templateList
                            .map((template) => TemplateTabMenu(
                                  text: template,
                                  isSelected: selectedTemplate == template,
                                  onTap: () => toggleTemplate(template),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: PaddingContainer(
                      child: GapColumn(
                        gap: 16,
                        children: routinesToShow
                            .map(
                              (routine) => ListItem(
                                id: -1,
                                title: routine.goal,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TemplateDetailScreen(
                                        routine: routine,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Center(
              child: Text(
                '서비스 준비 중',
                style: AppTextStyles.REGULAR_16
                    .copyWith(color: AppColors.TEXT_SUB),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TemplateDetailScreen extends ConsumerWidget {
  final RoutineTemplate routine;

  const TemplateDetailScreen({super.key, required this.routine});

  String getTotalDuration() {
    int totlaDuration = routine.subRoutines
        .fold(0, (sum, subRoutine) => sum + subRoutine.duration);
    return '${(totlaDuration ~/ 60).toString()}분';
  }

  @override
  Widget build(BuildContext context, ref) {
    return DefaultLayout(
      title: '템플릿 상세',
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
                        Text(routine.goal, style: AppTextStyles.BOLD_20),
                        const SizedBox(height: 24),
                        Text("총 소요시간",
                            style: AppTextStyles.MEDIUM_14.copyWith(
                              color: AppColors.TEXT_SUB,
                            )),
                        const SizedBox(height: 8),
                        Text(getTotalDuration(), style: AppTextStyles.BOLD_20),
                      ],
                    ),
                  ),
                  PaddingContainer(
                    child: GapColumn(
                      gap: 16,
                      children: [
                        const Text("세부 루틴", style: AppTextStyles.BOLD_20),
                        ...routine.subRoutines.map(
                          (subRoutine) => ListItem(
                            id: 0,
                            title: subRoutine.goal,
                            subTitle:
                                '${(subRoutine.duration ~/ 60).toString()}분',
                            routinEmoji: subRoutine.emoji,
                            actionIcon: Icons.add,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TemplateDetailAddScreen(
                                    routine: routine,
                                    selectedRoutine: subRoutine,
                                  ),
                                ),
                              );
                            },
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      RoutineCreateScreen(routineTemplate: routine),
                ),
              );
            },
            title: "한번에 루틴 추가히기",
            backgroundColor: AppColors.BRAND,
            foregroundColor: Colors.white,
          ))
        ],
      ),
    );
  }
}

class TemplateDetailAddScreen extends StatefulWidget {
  final RoutineTemplate routine;
  final SubRoutineTemplate selectedRoutine;

  const TemplateDetailAddScreen(
      {super.key, required this.routine, required this.selectedRoutine});

  @override
  State<TemplateDetailAddScreen> createState() =>
      _TemplateDetailAddScreenState();
}

class _TemplateDetailAddScreenState extends State<TemplateDetailAddScreen> {
  List<SubRoutineTemplate> selectedSubRoutines = [];

  @override
  void initState() {
    selectedSubRoutines.add(widget.selectedRoutine);
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '개별 추가',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GapColumn(
            gap: 16,
            children: [
              const PaddingContainer(
                width: double.infinity,
                child: GapColumn(
                  children: [
                    Text("어느 루틴에 추가할까요?", style: AppTextStyles.BOLD_20),
                    SizedBox(height: 16),
                    GapRow(
                      gap: 8,
                      children: [
                        Text("새 루틴 생성하기", style: AppTextStyles.MEDIUM_20),
                        Icon(Icons.keyboard_arrow_down, size: 30)
                      ],
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
                        id: 0,
                        title: subRoutine.goal,
                        subTitle: '${(subRoutine.duration ~/ 60).toString()}분',
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
          PaddingContainer(
              child: CustomButton(
            onPressed: () {},
            title: "세부 루틴 추가히기",
            backgroundColor: AppColors.BRAND,
            foregroundColor: Colors.white,
          ))
        ],
      ),
    );
  }
}

class TemplateTabMenu extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const TemplateTabMenu({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          borderRadius: AppRadius.ROUNDED_36,
          color: isSelected ? AppColors.BRAND_SUB : AppColors.BACKGROUND_SUB,
        ),
        child: Text(
          text,
          style: isSelected
              ? AppTextStyles.BOLD_14.copyWith(color: AppColors.BRAND)
              : AppTextStyles.REGULAR_14
                  .copyWith(color: AppColors.TEXT_SECONDARY),
        ),
      ),
    );
  }
}

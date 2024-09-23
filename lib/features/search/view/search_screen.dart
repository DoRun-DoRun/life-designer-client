import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:dorun_app_flutter/features/search/model/search_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                                routineId: -1,
                                title: routine.goal,
                                onTap: () {
                                  context.push(
                                    '/template_detail',
                                    extra: routine,
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

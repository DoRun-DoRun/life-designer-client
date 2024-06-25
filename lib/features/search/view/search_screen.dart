import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: DefaultLayout(
        customAppBar: AppBar(
          title: const Text('둘러보기', style: AppTextStyles.MEDIUM_16),
          bottom: const TabBar(
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(width: 4, color: AppColors.BRAND),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.TEXT_BRAND,
              unselectedLabelColor: AppColors.TEXT_SUB,
              labelStyle: AppTextStyles.BOLD_14,
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
                  child: const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: PaddingContainer(
                      child: GapRow(
                        gap: 10,
                        children: [
                          TemplateTabMenu(text: "전체"),
                          TemplateTabMenu(text: "전체"),
                          TemplateTabMenu(text: "전체"),
                          TemplateTabMenu(text: "전체"),
                          TemplateTabMenu(text: "전체"),
                          TemplateTabMenu(text: "전체"),
                          TemplateTabMenu(text: "전체"),
                          TemplateTabMenu(text: "전체"),
                        ],
                      ),
                    ),
                  ),
                ),
                PaddingContainer(
                  child: GapColumn(
                    gap: 16,
                    children: [
                      ListItem(
                        id: 0,
                        title: "아침 조깅하기",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TemplateDetailScreen(),
                            ),
                          );
                        },
                      ),
                      const ListItem(id: 0, title: "아침 조깅하기"),
                      const ListItem(id: 0, title: "아침 조깅하기"),
                      const ListItem(id: 0, title: "아침 조깅하기"),
                    ],
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

class TemplateDetailScreen extends StatelessWidget {
  const TemplateDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        const Text("아침 조깅하기", style: AppTextStyles.BOLD_20),
                        const SizedBox(height: 24),
                        Text("총 소요시간",
                            style: AppTextStyles.MEDIUM_14.copyWith(
                              color: AppColors.TEXT_SUB,
                            )),
                        const SizedBox(height: 8),
                        const Text("111분", style: AppTextStyles.BOLD_20),
                      ],
                    ),
                  ),
                  PaddingContainer(
                    child: GapColumn(
                      gap: 16,
                      children: [
                        const Text("세부 루틴", style: AppTextStyles.BOLD_20),
                        ListItem(
                          id: 0,
                          routinEmoji: '🪟',
                          title: "창문열기",
                          subTitle: "1분",
                          actionIcon: Icons.add,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TemplateDetailAddScreen(),
                              ),
                            );
                          },
                        ),
                        const ListItem(id: 0, title: "창문열기"),
                        const ListItem(id: 0, title: "창문열기"),
                        const ListItem(id: 0, title: "창문열기"),
                        const ListItem(id: 0, title: "창문열기"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          PaddingContainer(
              child: CustomButton(
            onPressed: () {},
            title: "루틴 추가히기",
            backgroundColor: AppColors.BRAND,
            foregroundColor: Colors.white,
          ))
        ],
      ),
    );
  }
}

class TemplateDetailAddScreen extends StatelessWidget {
  const TemplateDetailAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '개별 추가',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const GapColumn(
            gap: 16,
            children: [
              PaddingContainer(
                width: double.infinity,
                child: GapColumn(
                  children: [
                    Text("어느 루틴에 추가할까요?", style: AppTextStyles.BOLD_20),
                    SizedBox(height: 16),
                    GapRow(
                      gap: 8,
                      children: [
                        Text("내 루틴A", style: AppTextStyles.MEDIUM_20),
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
                    Text("추가할 세부 루틴을 선택해주세요", style: AppTextStyles.BOLD_20),
                    ListItem(
                      id: 0,
                      routinEmoji: '🪟',
                      title: "창문열기",
                      subTitle: "1분",
                      actionIcon: Icons.check,
                      actionIconColor: AppColors.BRAND,
                    ),
                    ListItem(id: 0, title: "창문열기"),
                    ListItem(id: 0, title: "창문열기"),
                    ListItem(id: 0, title: "창문열기"),
                    ListItem(id: 0, title: "창문열기"),
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

  const TemplateTabMenu({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: const BoxDecoration(
        borderRadius: AppRadius.ROUNDED_36,
        color: AppColors.BRAND_SUB,
      ),
      child: Text(
        text,
        style: AppTextStyles.BOLD_14.copyWith(
          color: AppColors.BRAND,
        ),
      ),
    );
  }
}

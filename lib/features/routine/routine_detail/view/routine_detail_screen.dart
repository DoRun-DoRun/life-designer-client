import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/list_item.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/data.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoutineDetailScreen extends StatelessWidget {
  final int id;
  const RoutineDetailScreen({super.key, required this.id});

  static String get routeName => 'routineDetail';

  Routine? getRoutineById(int id) {
    try {
      return routineMockData.firstWhere((routine) => routine.id == id);
    } catch (e) {
      return routineMockData[0];
    }
  }

  void _showAddRoutineModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // 모달을 전체 화면으로 확장
        builder: (BuildContext bc) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets, // 키보드 높이에 따라 패딩 조정
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                children: <Widget>[
                  const Text('세부 루틴 추가',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  DropdownButton<IconData>(
                    isExpanded: true,
                    items: <IconData>[
                      Icons.fitness_center,
                      Icons.directions_run,
                      Icons.pool
                    ].map((IconData value) {
                      return DropdownMenuItem<IconData>(
                        value: value,
                        child: Icon(value),
                      );
                    }).toList(),
                    onChanged: (_) {},
                    hint: const Text('아이콘 선택'),
                  ),
                  const TextField(
                    decoration: InputDecoration(
                      hintText: '세부 루틴 설명',
                    ),
                  ),
                  const TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '세부 루틴 소요 시간(분)',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // 모달 창 닫기
                    },
                    child: const Text('추가하기'),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: GapColumn(
              gap: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaddingContainer(
                  width: double.infinity,
                  child: GapColumn(
                    gap: 24,
                    children: [
                      Text(getRoutineById(id)!.name,
                          style: AppTextStyles.BOLD_20),
                      GapColumn(
                        gap: 8,
                        children: [
                          Text(
                            "총 소요시간",
                            style: AppTextStyles.MEDIUM_14
                                .copyWith(color: AppColors.TEXT_SUB),
                          ),
                          Text(
                              "${getRoutineById(id)!.totalDuration.toString()} 분",
                              style: AppTextStyles.MEDIUM_20),
                        ],
                      ),
                    ],
                  ),
                ),
                PaddingContainer(
                  child: GapColumn(
                    gap: 16,
                    children: getRoutineById(id)!.subRoutines.map((data) {
                      return ListItem(
                        id: data.id,
                        title: data.name,
                        routinEmoji: data.emoji,
                        subTitle: '${data.duration.toString()}분',
                      );
                    }).toList(),
                  ),
                ),
                PaddingContainer(
                    child: Column(
                  children: [
                    GapColumn(
                      gap: 16,
                      children: [
                        const Text(
                          "루틴을 수행하고 있는지 작성해주세요",
                          style: AppTextStyles.MEDIUM_16,
                        ),
                        CustomButton(
                          onPressed: () => {},
                          title: '',
                          icon: const Icon(
                            Icons.add_circle,
                            size: 25,
                            color: AppColors.TEXT_BRAND,
                          ),
                        )
                      ],
                    ),
                  ],
                ))
              ],
            ),
          ),
          PaddingContainer(
            child: CustomButton(
              title: '수행하기',
              backgroundColor: AppColors.BRAND,
              foregroundColor: AppColors.BRAND_SUB,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

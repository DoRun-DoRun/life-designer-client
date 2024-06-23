import 'package:dorun_app_flutter/common/component/custom_button.dart';
import 'package:dorun_app_flutter/common/component/custom_icon.dart';
import 'package:dorun_app_flutter/common/component/gap_column.dart';
import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/component/padding_container.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:dorun_app_flutter/common/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: DefaultLayout(
          customAppBar: AppBar(
            title: const Text(
              '통계',
              style: AppTextStyles.MEDIUM_16,
            ),
            bottom: const TabBar(
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 4,
                    color: AppColors.BRAND,
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppColors.TEXT_BRAND,
                unselectedLabelColor: AppColors.TEXT_SUB,
                tabs: [
                  Tab(
                    child: Text(
                      "기간별",
                      style: AppTextStyles.BOLD_14,
                    ),
                  ),
                  Tab(
                    child: Text(
                      "루틴별",
                      style: AppTextStyles.BOLD_14,
                    ),
                  ),
                ]),
          ),
          child: const TabBarView(
            children: [
              StatisticsPeriodScreen(),
              StatisticsRoutineScreen(),
            ],
          ),
        ),
      ),
    );
  }
}

class StatisticsPeriodScreen extends StatelessWidget {
  const StatisticsPeriodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GapColumn(
        gap: 24,
        children: [
          PaddingContainer(
            child: GapColumn(
              gap: 24,
              children: [
                RichText(
                  text: TextSpan(
                    text: '지금까지 ',
                    style: AppTextStyles.BOLD_20,
                    children: <TextSpan>[
                      TextSpan(
                        text: '연속 15일 ',
                        style: AppTextStyles.BOLD_20.copyWith(
                          color: AppColors.TEXT_BRAND,
                        ),
                      ),
                      const TextSpan(
                        text: '동안 \n루틴을 100% 달성했어요',
                      ),
                    ],
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '최고 연속 달성',
                      style: AppTextStyles.REGULAR_14,
                    ),
                    Text(
                      '24일',
                      style: AppTextStyles.BOLD_16,
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '누적 연속 달성',
                      style: AppTextStyles.REGULAR_14,
                    ),
                    Text(
                      '24일',
                      style: AppTextStyles.BOLD_16,
                    ),
                  ],
                ),
              ],
            ),
          ),
          PaddingContainer(
            child: Column(
              children: [
                const Calendar(),
                const Divider(),
                GapColumn(
                  gap: 24,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: const TextSpan(
                              style: AppTextStyles.REGULAR_16,
                              children: [
                                TextSpan(
                                  text: "완료1   ",
                                  style: TextStyle(
                                    color: AppColors.TEXT_BRAND,
                                  ),
                                ),
                                TextSpan(
                                  text: "실패2   ",
                                ),
                                TextSpan(
                                  text: "건너뜀1",
                                  style: TextStyle(
                                    color: AppColors.TEXT_SUB,
                                  ),
                                )
                              ]),
                        ),
                        const Icon(
                          size: 30,
                          Icons.keyboard_arrow_up_outlined,
                        )
                      ],
                    ),
                    const IconListView(
                      text: '아침 조깅하기',
                      icon: Icons.check,
                    ),
                    const IconListView(
                      text: '아침 조깅하기',
                      icon: Icons.close,
                      color: AppColors.BRAND_SUB,
                    ),
                  ],
                )
              ],
            ),
          ),
          PaddingContainer(
            child: GapColumn(
              gap: 24,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GapColumn(
                      gap: 8,
                      children: [
                        RichText(
                          text: const TextSpan(
                            text: "지난 주에 비해\n",
                            style: AppTextStyles.BOLD_20,
                            children: <TextSpan>[
                              TextSpan(
                                text: '12% 더\n달성했네요',
                                style: TextStyle(
                                  color: AppColors.TEXT_BRAND,
                                ),
                              )
                            ],
                          ),
                        ),
                        const Text(
                          "04.21 ~ 04.27",
                          style: AppTextStyles.REGULAR_14,
                        )
                      ],
                    ),
                    const CircularProgress(
                      progressNow: 0.6,
                      progressBefore: 0.48,
                    )
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconListView(
                      text: '아침 조깅하기',
                      icon: Icons.close,
                      color: AppColors.BRAND_SUB,
                    ),
                    Text(
                      '24개',
                      style: AppTextStyles.BOLD_16,
                    )
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconListView(
                      text: '아침 조깅하기',
                      icon: Icons.close,
                      color: AppColors.BRAND_SUB,
                    ),
                    Text(
                      '24개',
                      style: AppTextStyles.BOLD_16,
                    )
                  ],
                ),
                CustomButton(
                  onPressed: () {},
                  title: '자세히 보기',
                  backgroundColor: AppColors.BRAND_SUB,
                  foregroundColor: AppColors.TEXT_BRAND,
                )
              ],
            ),
          ),
          PaddingContainer(
            child: GapColumn(
              gap: 24,
              children: [
                GapColumn(
                  gap: 8,
                  children: [
                    const Text(
                      "최근 어려워한 루틴이에요",
                      style: AppTextStyles.BOLD_20,
                    ),
                    Text(
                      "단순한 루틴의 달성률이 68% 더 높게 나타나요.\n조금 더 간단하게 해보는 건 어떨까요?",
                      style: AppTextStyles.REGULAR_14.copyWith(
                        color: AppColors.TEXT_SUB,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.BACKGROUND_SUB,
                    borderRadius: AppRadius.ROUNDED_16,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: GapColumn(
                      gap: 16,
                      children: [
                        Text(
                          "아침 조깅하기",
                          style: AppTextStyles.BOLD_14,
                        ),
                        Row(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class IconListView extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const IconListView({
    super.key,
    required this.text,
    required this.icon,
    this.color = AppColors.BRAND,
  });

  @override
  Widget build(BuildContext context) {
    return GapRow(
      gap: 8,
      children: [
        CustomIcon(
          icon: icon,
          primaryColor: color,
        ),
        Text(
          text,
          style: AppTextStyles.REGULAR_14,
        )
      ],
    );
  }
}

class StatisticsRoutineScreen extends StatelessWidget {
  const StatisticsRoutineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {},
            ),
            const Text('2024.04',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {},
            ),
          ],
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: 30,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: CircleAvatar(
                backgroundColor:
                    index % 2 == 0 ? Colors.blue : Colors.grey[300],
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                      color: index % 2 == 0 ? Colors.white : Colors.black),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class CircularProgress extends StatelessWidget {
  final double outerThickness;
  final double innerThickness;
  final double progressNow;
  final double progressBefore;
  final double size;

  const CircularProgress({
    super.key,
    this.outerThickness = 10,
    this.innerThickness = 10,
    required this.progressNow,
    required this.progressBefore,
    this.size = 154.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: CirclePainter(
              progress: progressNow,
              thickness: outerThickness,
              color: AppColors.BRAND,
            ),
          ),
          SizedBox(
            width: size - outerThickness * 2,
            height: size - outerThickness * 2,
            child: CustomPaint(
              size: Size(size - outerThickness * 2, size - outerThickness * 2),
              painter: CirclePainter(
                progress: progressBefore,
                thickness: innerThickness,
                color: AppColors.TEXT_INVERT,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(progressNow * 100).toInt()}%',
                  style: AppTextStyles.BOLD_20.copyWith(
                    fontSize: 32,
                    color: AppColors.TEXT_BRAND,
                  ),
                ),
                Text(
                  '지난 주 ${(progressBefore * 100).toInt()}%',
                  style: AppTextStyles.REGULAR_12.copyWith(
                    color: AppColors.TEXT_SUB,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final double progress;
  final double thickness;
  final Color color;

  CirclePainter({
    required this.progress,
    required this.thickness,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double radius = (size.width / 2) - thickness / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    Paint baseCircle = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;

    Paint progressCircle = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, baseCircle);

    double sweepAngle = 2 * 3.141592653589793 * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      progressCircle,
    );
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

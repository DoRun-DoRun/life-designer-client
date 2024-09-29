import 'package:dorun_app_flutter/common/component/gap_row.dart';
import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:dorun_app_flutter/common/constant/fonts.dart';
import 'package:dorun_app_flutter/common/constant/spacing.dart';
import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  TrianglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.BRAND
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isLoading;
  final int loadingDots;

  const ChatBubble({
    super.key,
    required this.text,
    this.isLoading = false,
    this.loadingDots = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 108.0, // 최소 너비 설정
            minHeight: 58,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.BRAND,
              borderRadius: AppRadius.ROUNDED_16,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            child: isLoading
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GapRow(
                      gap: 10,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(loadingDots, (index) {
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          decoration: const BoxDecoration(
                            color: AppColors.BRAND_SUB,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                    ),
                  )
                : Text(
                    text,
                    style: AppTextStyles.BOLD_20
                        .copyWith(color: Colors.white, height: 2),
                    textAlign: TextAlign.start,
                  ),
          ),
        ),
        Positioned(
          bottom: -13, // 삼각형의 높이 절반만큼 이동
          child: CustomPaint(
            size: const Size(58, 26),
            painter: TrianglePainter(),
          ),
        ),
      ],
    );
  }
}

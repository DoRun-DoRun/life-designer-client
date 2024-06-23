import 'package:dorun_app_flutter/common/constant/colors.dart';
import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;
  final String text;
  final double progress;

  const CustomIcon({
    super.key,
    this.size = 24.0,
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.white,
    this.icon = Icons.add,
    this.text = '',
    this.progress = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: ProgressPainter(progress: progress),
          ),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: text == ''
                ? Icon(
                    icon,
                    color: secondaryColor,
                    size: 16,
                  )
                : Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;

  ProgressPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress > 0) {
      Paint paint = Paint()
        ..color = AppColors.BRAND // 진행 표시 색상
        ..strokeWidth = 3.0 // 진행 표시 굵기
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      double radius = (size.width / 2) + 6; // 외부 원의 반지름
      double angle = 2 * 3.141592653589793 * progress;

      Offset center = Offset(size.width / 2, size.height / 2);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -3.141592653589793 / 2, // 시작 각도 (위쪽)
        angle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 228, 228, 228)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width / 1.4, size.height * 0.57);
    path.cubicTo(
      size.width / 2.5 + 100,
      size.height * 1 + 50,
      size.width / 0.85 + 50,
      size.height * 0.4,
      size.width / 2,
      size.height * 0.8,
    );

    path.cubicTo(size.width / 5, size.height * 0.95, size.width / 2,
        size.height * 0.62, size.width / 2, size.height * 0.9);

    path.lineTo(size.width / 2, size.height * 0.9);
    path.moveTo(size.width / 2 - 10, size.height * 0.88);
    path.lineTo(size.width / 2, size.height * 0.9);
    path.lineTo(size.width / 2 + 10, size.height * 0.88);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Heart Flower',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.pink, fontFamily: 'Roboto'),
      home: const HeartFlowerPage(),
    );
  }
}

class HeartFlowerPage extends StatelessWidget {
  const HeartFlowerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = min(
              constraints.maxWidth * 0.9,
              constraints.maxHeight * 0.9,
            );
            return SizedBox(
              width: size,
              height: size,
              child: const HeartFlower(),
            );
          },
        ),
      ),
    );
  }
}

class HeartFlower extends StatefulWidget {
  const HeartFlower({super.key});

  @override
  State<HeartFlower> createState() => _HeartFlowerState();
}

class _HeartFlowerState extends State<HeartFlower>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Controller for rotating the flower
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    // Controller for the pulsating animation
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: CustomPaint(
                  painter: HeartFlowerPainter(
                    animationValue: _controller.value,
                  ),
                  size: Size.infinite,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class HeartFlowerPainter extends CustomPainter {
  final double animationValue;

  HeartFlowerPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2.5;

    // Center text instead of center heart
    final centerTextPaint =
        Paint()
          ..color = Colors.purple[050]!
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.35, centerTextPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: "I love you Ayomide Somotan\n",
            style: GoogleFonts.dancingScript(
              fontSize: radius * 0.1,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          TextSpan(
            text: "to the moon and back,\nalways and forever",
            style: GoogleFonts.dancingScript(
              fontSize: radius * 0.08,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();
    canvas.drawPaint(centerTextPaint);
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );

    // Draw heart petals
    final petalCount = 12;
    for (int i = 0; i < petalCount; i++) {
      final angle = (i / petalCount * 2 * pi) + (animationValue * 2 * pi);
      final petalCenter = Offset(
        center.dx + cos(angle) * radius * 0.85,
        center.dy + sin(angle) * radius * 0.85,
      );

      // Alternate colors for petals
      final color =
          i % 3 == 0
              ? Colors.red[300]!
              : i % 3 == 1
              ? Colors.pink[300]!
              : Colors.purple[300]!;

      drawHeart(canvas, petalCenter, radius * 0.3, color);
    }

    // Draw small decorative hearts
    final smallHeartCount = 24;
    for (int i = 0; i < smallHeartCount; i++) {
      final angle =
          (i / smallHeartCount * 2 * pi) - (animationValue * 2 * pi * 0.5);
      final distance = radius * 1.4;
      final smallHeartCenter = Offset(
        center.dx + cos(angle) * distance,
        center.dy + sin(angle) * distance,
      );

      final smallHeartSize = radius * 0.12;
      final color =
          i % 4 == 0
              ? Colors.red[200]!
              : i % 4 == 1
              ? Colors.pink[200]!
              : i % 4 == 2
              ? Colors.purple[200]!
              : Colors.deepPurple[200]!;

      drawHeart(canvas, smallHeartCenter, smallHeartSize, color);
    }
  }

  void drawHeart(Canvas canvas, Offset center, double size, Color color) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill
          ..strokeWidth = 2;

    final path = Path();

    // Heart shape
    path.moveTo(center.dx, center.dy + size * 0.3);

    // Left curve
    path.cubicTo(
      center.dx - size * 0.8,
      center.dy - size * 0.2, // control point 1
      center.dx - size * 0.8,
      center.dy - size * 1.2, // control point 2
      center.dx,
      center.dy - size * 0.5, // end point
    );

    // Right curve
    path.cubicTo(
      center.dx + size * 0.8,
      center.dy - size * 1.2, // control point 1
      center.dx + size * 0.8,
      center.dy - size * 0.2, // control point 2
      center.dx,
      center.dy + size * 0.3, // end point
    );

    canvas.drawPath(path, paint);

    // Add light reflection/shine on the heart
    // final shinePaint =
    //     Paint()
    //       ..color = color.withOpacity(0.3)
    //       ..style = PaintingStyle.fill;
    //
    // final shinePath = Path();
    // shinePath.moveTo(center.dx - size * 0.3, center.dy - size * 0.5);
    // shinePath.cubicTo(
    //   center.dx - size * 0.1,
    //   center.dy - size * 0.7,
    //   center.dx + size * 0.1,
    //   center.dy - size * 0.7,
    //   center.dx + size * 0.3,
    //   center.dy - size * 0.5,
    // );
    //
    // canvas.drawPath(shinePath, shinePaint);
  }

  @override
  bool shouldRepaint(HeartFlowerPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class CurvedText extends StatelessWidget {
  final String text;
  final double radius;
  final TextStyle textStyle;

  const CurvedText({
    Key? key,
    required this.text,
    required this.radius,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CurvedTextPainter(
        text: text,
        radius: radius,
        textStyle: textStyle,
      ),
      size: Size(radius * 2, radius),
    );
  }
}

class CurvedTextPainter extends CustomPainter {
  final String text;
  final double radius;
  final TextStyle textStyle;

  CurvedTextPainter({
    required this.text,
    required this.radius,
    required this.textStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Position at the top of the semicircle instead of bottom
    canvas.translate(size.width / 2, 0);

    final textSpan = TextSpan(text: text, style: textStyle);

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final textWidth = textPainter.width;

    // Calculate the angle for each character
    // Start from 0 and go to pi for top semicircle
    double startAngle = (textWidth / radius) / 2;

    for (int i = 0; i < text.length; i++) {
      final charTextSpan = TextSpan(text: text[i], style: textStyle);

      final charTextPainter = TextPainter(
        text: charTextSpan,
        textDirection: TextDirection.ltr,
      );

      charTextPainter.layout();

      final charWidth = charTextPainter.width;
      final halfCharWidth = charWidth / 2;
      final angle = startAngle - (halfCharWidth / radius);

      canvas.save();

      canvas.rotate(angle);
      canvas.translate(0, radius);

      charTextPainter.paint(canvas, Offset(-halfCharWidth, 0));

      canvas.restore();

      startAngle -= charWidth / radius;
    }
  }

  @override
  bool shouldRepaint(CurvedTextPainter oldDelegate) {
    return oldDelegate.text != text ||
        oldDelegate.radius != radius ||
        oldDelegate.textStyle != textStyle;
  }
}

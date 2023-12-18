import 'package:flutter/material.dart';

class Shape {
  String type;
  Offset position;
  Color color;

  Shape({required this.type, required this.position, required this.color});
}

class DrawShapes extends CustomPainter {
  List<Shape> shapes;

  DrawShapes({required this.shapes});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    for (Shape shape in shapes) {
      Paint paint = Paint()
        ..color = shape.color
        ..style = PaintingStyle.fill;

      if (shape.type == "Circle") {
        canvas.drawCircle(shape.position, size.width / 2, paint);
      } else if (shape.type == "Rectangle") {
        canvas.drawRect(
          Rect.fromPoints(
            shape.position,
            Offset(shape.position.dx + size.width, shape.position.dy + size.height),
          ),
          paint,
        );
      } else if (shape.type == "Pentagon") {
        Path path = Path()
          ..moveTo(shape.position.dx + size.width / 2, shape.position.dy)
          ..lineTo(shape.position.dx + size.width, shape.position.dy + size.height / 3)
          ..lineTo(shape.position.dx + size.width * 2 / 3, shape.position.dy + size.height)
          ..lineTo(shape.position.dx + size.width * 1 / 3, shape.position.dy + size.height)
          ..lineTo(shape.position.dx, shape.position.dy + size.height / 3)
          ..close();
        canvas.drawPath(path, paint);
      } else if (shape.type == "Triangle") {
        Path path = Path()
          ..moveTo(shape.position.dx + size.width / 2, shape.position.dy)
          ..lineTo(shape.position.dx, shape.position.dy + size.height)
          ..lineTo(shape.position.dx + size.width, shape.position.dy + size.height)
          ..close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

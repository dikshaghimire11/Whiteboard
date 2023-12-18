import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'DrawShapes.dart';
import 'DrawingArea.dart';
import 'ShowTextDialog.dart';

class DrawPaint extends StatefulWidget {
  const DrawPaint({Key? key}) : super(key: key);

  @override
  State<DrawPaint> createState() => _DrawPaintState();
}

class _DrawPaintState extends State<DrawPaint> {
  List<DrawingArea?> point = [];
  late Color selectedColor;
  late double strokeWidth;
  String selectedValue = 'Circle';
  String DrawingTool="Pen";
  Offset position = Offset(0, 0);
  List<Shape> shapes = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedColor = Colors.black;
    strokeWidth = 2.0;
  }

  void selectColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select a Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();
                });
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(0, 64, 112, 1.0),
                  Color.fromRGBO(100, 64, 87, 1.0),
                  Color.fromRGBO(150, 113, 33, 1.0),
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: width * 0.90,
                  height: height * 0.75,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      )
                    ],

                  ),
                  child: GestureDetector(
                    onPanDown: (details) {
                      RenderBox renderBox = context.findRenderObject() as RenderBox;
                      setState(() {
                        point.add(DrawingArea(
                          point: renderBox.globalToLocal(details.globalPosition),
                          areaPaint: Paint()
                            ..color = selectedColor
                            ..strokeCap = StrokeCap.round
                            ..isAntiAlias = true
                            ..strokeWidth = strokeWidth,
                        ));
                      });
                    },
                    onPanUpdate: (details) {
                      RenderBox renderBox = context.findRenderObject() as RenderBox;
                      setState(() {
                        if (DrawingTool == "Pen") {
                          point.add(DrawingArea(
                            point: renderBox.globalToLocal(details.globalPosition),
                            areaPaint: Paint()
                              ..color = selectedColor
                              ..strokeCap = StrokeCap.round
                              ..isAntiAlias = true
                              ..strokeWidth = strokeWidth,
                          ));
                        }  if (shapes.isNotEmpty) {
                          shapes.last.position += details.delta;
                        }
                      });
                    },
                    onPanEnd: (details) {
                    // Handle pen drawing
                    setState(() {
                      point.add(null);
                    });
                  },

                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: DrawingTool == "Pen"
                              ? SketchPainter(
                              points: point,
                              selectedColor: selectedColor,
                              strokeWidth: strokeWidth)
                              :  DrawShapes(shapes: shapes),
                        size: Size(200, 200),
                        ),
                      ),
                    ),
                  ),

                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: width * 0.90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Expanded(
                      child: Slider(
                          min: 2.0,
                          max: 15.0,
                          activeColor: Colors.black,
                          value: strokeWidth,
                          onChanged: (value) {
                            this.setState(() {
                              strokeWidth = value;
                            });
                          })),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  width: width * 0.90,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            selectColor();
                          },
                          icon: Icon(
                            Icons.color_lens,
                            color: Colors.black,
                          )),
                      DropdownButton<String>(
                        value: selectedValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            DrawingTool = "";
                            selectedValue = newValue!;
                            if (DrawingTool != "Pen") {
                              shapes.add(Shape(
                                type: selectedValue,
                                position: position, // Use the current position or adjust as needed
                                color: selectedColor,
                              ));
                            }
                          });
                        },
                        items: ['Circle', 'Rectangle', 'Pentagon', 'Triangle']
                            .map<DropdownMenuItem<String>>((String value) {
                          IconData iconData;
                          switch (value) {
                            case 'Circle':
                              iconData = Icons.circle;
                              break;
                            case 'Rectangle':
                              iconData = Icons.rectangle;
                              break;
                            case 'Pentagon':
                              iconData = Icons.pentagon;
                              break;
                            case 'Triangle':
                              iconData = Icons.change_history;
                              break;
                            default:
                              iconData = Icons.star;
                          }

                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                Icon(iconData),
                                SizedBox(width: 8),
                                Text(value),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      IconButton(
                          onPressed: () {
                            selectedColor = Colors.black;
                            DrawingTool="Pen";
                          },
                          icon: Image.asset(
                            'assets/pensil.png',
                            height: 20.0,
                          )),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ShowTextDialog();
                              },
                            );
                          },
                          icon: Icon(
                            Icons.text_fields_sharp,
                            color: Colors.black,
                          )),
                      IconButton(
                          onPressed: () {
                            selectedColor = Colors.white;
                          },
                          icon: Image.asset(
                            'assets/eraser.png',
                            height: 20.0,
                          )),
                      IconButton(
                        onPressed: () {
                          this.setState(() {
                            point.clear();
                            shapes.clear();
                          });
                        },
                        icon: Icon(
                          Icons.layers_clear,
                          color: Colors.black,
                        ),
                      )
                    ],
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

class SketchPainter extends CustomPainter {
  List<DrawingArea?> points;
  Color selectedColor;
  double strokeWidth;

  SketchPainter(
      {required this.points,
      required this.selectedColor,
      required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        Paint? paint = points[i]?.areaPaint;
        canvas.drawLine(points[i]!.point!, points[i + 1]!.point, paint!);
      } else if (points[i] != null && points[i + 1] == null) {
        Paint? paint = points[i]?.areaPaint;
        canvas.drawPoints(PointMode.points, [points[i]!.point], paint!);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

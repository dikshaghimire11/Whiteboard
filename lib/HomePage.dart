import 'package:flutter/material.dart';
import 'package:whiteboard_app/CustomColor.dart';
import 'package:whiteboard_app/DrawPaint.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("WhiteBoard")),
        backgroundColor: CustomColor().themeColor,
      ),
      body: Container(
        color: Colors.white10,
        child: LayoutBuilder(
          builder: (context, parentBuilder) => Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left
            children: [
              SizedBox(
                height: 10, // Adjust the height as needed
              ),
              Expanded(
                child: OrientationBuilder(
                  builder: (BuildContext context, Orientation orientation) {
                    return ListView.builder(
                      itemCount: 10, // Replace with the actual item count
                      itemBuilder: (BuildContext B, int index) {
                        return GestureDetector(
                          onTap: () {
                            onItemClick(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.9),
                                  spreadRadius: 2,
                                  blurRadius: 3,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // Adjust margin as needed
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: Colors.white, // Your desired background color
                              child: ListTile(
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.start, // Align text to the left
                                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                                  children: [
                                    Text("Title", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text("Title"),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("data"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomColor().themeColor,
        onPressed: () {
          setState(() {
            onButtonClick();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void onItemClick(int index) {

  }

  void onButtonClick() {
        Navigator.of(context).push(createRoute(DrawPaint()));

  }
  Route createRoute(Widget page) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: 0.0, end: 1.0);
          var curveTween = CurveTween(curve: Curves.linear);
          var myAnimation = animation.drive(tween.chain(curveTween));

          return FadeTransition(
            opacity: myAnimation,
            child: child,
          );
        });
  }
}

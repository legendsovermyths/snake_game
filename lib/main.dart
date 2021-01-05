import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Snakes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static Random rng = new Random();
  static List<int> snakePositions = [45, 65, 85, 105, 125];
  int numberOfSquare = 760;
  var duration = const Duration(milliseconds: 100);
  int foodPosition = rng.nextInt(700) - 1;
  void generateFood() {
    foodPosition = rng.nextInt(700) - 1;
  }

  String direction = "down";
  void startGame() {
    snakePositions = [45, 65, 85, 105, 125];
    Timer.periodic(duration, (timer) {
      updateSnake();
    });
  }

  void updateSnake() {
    setState(() {
      switch (direction) {
        case "down":
          if (snakePositions.last > 740) {
            snakePositions.add(snakePositions.last + 20 - 760);
          } else {
            snakePositions.add(snakePositions.last + 20);
          }
          break;
        case "up":
          if (snakePositions.last < 20) {
            snakePositions.add(snakePositions.last + 760 - 20);
          } else {
            snakePositions.add(snakePositions.last - 20);
          }
          break;
        case "left":
          if (snakePositions.last % 20 == 0) {
            snakePositions.add(snakePositions.last - 1 + 20);
          } else {
            snakePositions.add(snakePositions.last - 1);
          }
          break;
        case "right":
          if ((snakePositions.last + 1) % 20 == 0) {
            snakePositions.add(snakePositions.last + 1 - 20);
          } else {
            snakePositions.add(snakePositions.last + 1);
          }
          break;
        default:
      }
      if (snakePositions.last == foodPosition) {
        generateFood();
      } else {
        snakePositions.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 9,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != "down" && details.delta.dy < 0) {
                  print("left");

                  direction = 'up';
                }
                if (direction != 'up' && details.delta.dy > 0) {
                  print("right");
                  direction = 'down';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != "right" && details.delta.dx < 0) {
                  print("up");
                  direction = 'left';
                }
                if (direction != 'left' && details.delta.dx > 0) {
                  print("down");
                  direction = 'right';
                }
              },
              child: Container(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 20),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 760,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == foodPosition) {
                      return Center(
                          child: Container(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Color.fromRGBO(97, 177, 90, 1),
                          ),
                        ),
                      ));
                    }
                    if (snakePositions.contains(index)) {
                      return Center(
                          child: Container(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ));
                    }
                    return Center(
                        child: Container(
                      padding: EdgeInsets.all(2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          color: Color.fromRGBO(50, 50, 50, 1),
                        ),
                      ),
                    ));
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black54,
              child: Row(
                children: <Widget>[
                  MaterialButton(
                    child: Text(
                      "Start Game",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      startGame();
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

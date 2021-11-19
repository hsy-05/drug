//當按下Home按鈕時，出現的介面
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  CountdownTimerController controller;
  int endTime = DateTime.now().millisecondsSinceEpoch +
      Duration(seconds: 30).inMilliseconds +
      Duration(minutes: 1).inMilliseconds;

  @override
  void initState() {
    super.initState();
    controller =
        CountdownTimerController(endTime: endTime, onEnd: onEnd, vsync: this);
  }

  void onEnd() {
    print('onEnd');
  }

  @override
  Widget centreSection() {
    return Container(
      height: 600,
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 8,
          childAspectRatio: 0.65,
        ),
        children: [
          Container(
            color: Color.fromRGBO(210, 180, 140, 1.0),
            child: Center(
              child: const Text("下次吃藥時間",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),

          Container(
            color: Color.fromRGBO(210, 180, 140, 1.0),
            child: Center(
              child: const Text("下次吃藥時間",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),

          Container(
            color: Color.fromRGBO(210, 180, 140, 1.0),
            child: Center(
              child: const Text("下次吃藥時間",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),

          Container(
            color: Color.fromRGBO(210, 180, 140, 1.0),
            child: Center(
              child: const Text("下次吃藥時間",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(10.0),
          child: centreSection()),
    );
  }
}
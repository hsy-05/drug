//當按下Home按鈕時，出現的介面
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/authHome/model/time_entry.dart';
import 'package:flutter1/authHome/set_time.dart';
import 'package:flutter1/helpers/countDownTimer.dart';
import 'package:flutter1/helpers/device_input.dart';
import 'package:flutter_countdown_timer/index.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  CountdownTimerController controller;
  TimeOfDay n = TimeOfDay.now();
  int _endTime = new DateTime.now().millisecondsSinceEpoch ;
  // int endTime = DateTime.now().millisecondsSinceEpoch +
  //     Duration(seconds: 30).inMilliseconds +
  //     Duration(minutes: 0).inMilliseconds;

  DatabaseReference mainReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    controller =
        CountdownTimerController(endTime: _endTime, onEnd: onEnd, vsync: this);
    GetDeviceID().getd();
    mainReference =
        FirebaseDatabase.instance.reference().child("device").child(GetDeviceID.getDeviceID);
    drugAdb = mainReference.child("drugA");
    drugBdb = mainReference.child("drugB");
  }


  void onEnd() {
    print('時間到');
  }

  _HomeState() {
    mainReference.onChildAdded.listen(_onEntryAdded);
  }

  List<DrugARealtime> drugASaves = new List();
  List<DrugBRealtime> drugBSaves = new List();
  List<DrugCRealtime> drugCSaves = new List();
  List<DrugDRealtime> drugDSaves = new List();

  @override
  Widget build(BuildContext context) {
    final drugA = Ink(

        decoration: new BoxDecoration(
          //背景
          color: Color.fromRGBO(210, 180, 140, 1.0),
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          //设置四周边框
          border:
          new Border.all(width: 1, color: Color.fromRGBO(210, 180, 140, 1.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: StreamBuilder(
                  stream: StaticInfo.readItemsA(),
                  builder: (context, AsyncSnapshot<Event> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong'); //若連不上realtime會顯示
                    } else if (snapshot.hasData &&
                        snapshot.data.snapshot.value != null) {
                      return FirebaseAnimatedList(
                        query: drugAdb,
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index) {
                          String drugName = snapshot.value['drugText'];
                          String nickName = snapshot.value['nickName'];
                          print("藥品名稱：" + drugName);
                          DateTime fromDate =
                          (DateTime.parse(snapshot.value['fromDate1']));
                          DateTime toDate =
                          (DateTime.parse(snapshot.value['toDate']));
                          String timeString1 =snapshot.value['time1'];
                          TimeOfDay time1 = TimeOfDay(hour:int.parse(timeString1.split(":")[0]),minute: int.parse(timeString1.split(":")[1]));
                          String timeString2 =snapshot.value['time2'];
                          TimeOfDay time2 = TimeOfDay(hour:int.parse(timeString2.split(":")[0]),minute: int.parse(timeString2.split(":")[1]));
                          String timeString3 =snapshot.value['time3'];
                          TimeOfDay time3 = TimeOfDay(hour:int.parse(timeString3.split(":")[0]),minute: int.parse(timeString3.split(":")[1]));

                          int difmin1 = Duration(hours: time1.hour - n.hour).inMilliseconds;
                          int difsec1 = Duration(minutes: time1.minute - n.minute).inMilliseconds;
                          print("時間倒數：");
                          print(difmin1);
                          print(difsec1);
                          int endTime1 = _endTime + difmin1 + difsec1;

                          int difmin2 = Duration(hours: time2.hour - n.hour).inMilliseconds;
                          int difsec2 = Duration(minutes: time2.minute - n.minute).inMilliseconds;
                          print("時間倒數：");
                          print(difmin2);
                          print(difsec2);
                          int endTime2 = _endTime + difmin2 + difsec2;

                          int difmin3 = Duration(hours: time3.hour - n.hour).inMilliseconds;
                          int difsec3 = Duration(minutes: time3.minute - n.minute).inMilliseconds;
                          print("時間倒數：");
                          print(difmin3);
                          print(difsec3);
                          int endTime3 = _endTime + difmin3 + difsec3;

                          return new InkWell(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 80),
                                nickName.isEmpty ||
                                    nickName == null ||
                                    nickName == ""
                                    ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    new Text(
                                      "藥品名稱  ：",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    new Text(
                                      drugName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ) : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new Text(
                                      "藥品暱稱  ：",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 22,
                                      ),
                                    ),
                                    new Text(
                                      nickName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                                new Text("下次吃藥時間倒數",
                                    style: TextStyle(fontSize: 25)),
                                CountdownTimer(
                                  onEnd: onEnd,
                                  endTime: endTime1,
                                  widgetBuilder: (_, CurrentRemainingTime time) {
                                    if (time == null) {
                                      return Text('結束');
                                    }
                                    if(time.hours == null){
                                      return Text(
                                          ' 00 ： ${time.min} ', style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.red,
                                      ));
                                    }
                                    return Text(
                                        ' ${time.hours} ： ${time.min} ', style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.red,
                                    ));
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Text("尚未新增吃藥時間",style: TextStyle(
                          fontSize: 30) );
                    }
                  },
                ),
              ),
            ),
          ],
        ));

    final drugB = Ink(
        width: MediaQuery
            .of(context)
            .size
            .width / 2.0,
        height: MediaQuery
            .of(context)
            .size
            .height / 2.0,
        decoration: new BoxDecoration(
          //背景
          color: Color.fromRGBO(210, 180, 140, 1.0),
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          //设置四周边框
          border:
          new Border.all(width: 1, color: Color.fromRGBO(210, 180, 140, 1.0)),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: StreamBuilder(
                  stream: StaticInfo.readItemsB(),
                  builder: (context, AsyncSnapshot<Event> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong'); //若連不上realtime會顯示
                    } else if (snapshot.hasData &&
                        snapshot.data.snapshot.value != null) {
                      return FirebaseAnimatedList(
                        query: drugBdb,
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index) {
                          String drugName = snapshot.value['drugText'];
                          String nickName = snapshot.value['nickName'];
                          print("藥品名稱：" + drugName);
                          DateTime fromDate =
                          (DateTime.parse(snapshot.value['fromDate1']));
                          DateTime toDate =
                          (DateTime.parse(snapshot.value['toDate']));
                          String timeString =snapshot.value['time1'];
                          TimeOfDay time = TimeOfDay(hour:int.parse(timeString.split(":")[0]),minute: int.parse(timeString.split(":")[1]));

                          int difmin = Duration(hours: time.hour - n.hour).inMilliseconds;
                          int difsec = Duration(minutes: time.minute - n.minute).inMilliseconds;
                          print("時間倒數：");
                          print(difmin);
                          print(difsec);
                          int endTime1 = _endTime + difmin + difsec;

                          return new InkWell(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 80),
                                nickName.isEmpty ||
                                    nickName == null ||
                                    nickName == ""
                                    ? Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    new Text(
                                      "藥品名稱  ：",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    new Text(
                                      drugName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ) : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new Text(
                                      "藥品暱稱  ：",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 22,
                                      ),
                                    ),
                                    new Text(
                                      nickName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                                new Text("下次吃藥時間倒數",
                                    style: TextStyle(fontSize: 25)),
                                CountdownTimer(
                                  onEnd: onEnd,
                                  endTime: endTime1,
                                  widgetBuilder: (_, CurrentRemainingTime time) {
                                    if (time == null) {
                                      return Text('結束');
                                    }
                                    if(time.hours == null){
                                      return Text(
                                          ' 00 ： ${time.min} ', style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.red,
                                      ));
                                    }
                                    return Text(
                                        ' ${time.hours} ： ${time.min} ', style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.red,
                                    ));
                                  },
                                ),


                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                          child: Text("尚未新增吃藥時間",style: TextStyle(
                              fontSize: 30) )
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.17,
            ),

            children: [
              drugA,
              drugB,
            ],
          ),
          // child: centreSection()),
        ),
      ),
    );
  }


  // @override
  // Widget countDown() {
  //   return Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: <Widget>[
  //         CountdownTimer(
  //           textStyle: TextStyle(
  //             fontSize: 30,
  //             color: Colors.red,
  //           ),
  //           onEnd: onEnd,
  //           endTime: endTime,
  //         ),
  //         CountdownTimer(
  //           controller: controller,
  //           widgetBuilder: (_, CurrentRemainingTime time) {
  //             if (time == null) {
  //               return Text('Game over');
  //             }
  //             return Text(
  //                 'days: [ ${time.days} ], hours: [ ${time.hours} ], min: [ ${time.min} ], sec: [ ${time.sec} ]');
  //           },
  //         ),
  //       ],
  //     );
  // }

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

      ),
    );
  }

  _onEntryAdded(Event event) {
    if (!mounted) return; ////
    setState(() {
      userid = FirebaseAuth.instance.currentUser.uid;
      n = TimeOfDay.now();
      drugASaves.add(new DrugARealtime.fromSnapshot(event.snapshot));
      drugASaves
          .sort((we1, we2) => we1.fromDateTime.compareTo(we2.fromDateTime));

      drugBSaves.add(new DrugBRealtime.fromSnapshot(event.snapshot));
      drugBSaves
          .sort((we1, we2) => we1.fromDateTime.compareTo(we2.fromDateTime));

      drugCSaves.add(new DrugCRealtime.fromSnapshot(event.snapshot));
      drugCSaves
          .sort((we1, we2) => we1.fromDateTime.compareTo(we2.fromDateTime));
      drugDSaves.add(new DrugDRealtime.fromSnapshot(event.snapshot));
      drugDSaves
          .sort((we1, we2) => we1.fromDateTime.compareTo(we2.fromDateTime));
    });
  }

// Widget buildItem(String title, Widget page) {
//   return GestureDetector(
//     onTap: () {
//       Navigator.of(context).push(MaterialPageRoute(builder: (_) {
//         return page;
//       }));
//     },
//     child: Container(
//       margin: const EdgeInsets.all(5),
//       color: Colors.blue,
//       width: double.infinity,
//       alignment: Alignment.center,
//       height: 100,
//       child: Text(title, style: TextStyle(fontSize: 36),),
//     ),
//   );
// }
}
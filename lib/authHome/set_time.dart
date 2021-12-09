//當按下Home按鈕時，出現的介面
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/HomePage.dart';
import 'package:flutter1/authHome/time_content/edit_time_form.dart';
import 'package:flutter1/authHome/time_content/list_item.dart';
import 'package:flutter1/authHome/time_content/add_time_form.dart';
import 'package:flutter1/authHome/time_content/screens/add_drugA.dart';
import 'package:flutter1/authHome/time_content/screens/add_drugB.dart';
import 'package:flutter1/authHome/time_content/screens/edit_drugA.dart';
import 'package:flutter1/authHome/time_content/screens/edit_drugB.dart';
import 'package:flutter1/authHome/time_content/screens/edit_time.dart';
import 'package:flutter1/authHome/time_content/screens/med_mode.dart';
import 'package:flutter1/helpers/device_input.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:flutter1/authHome/model/time_firebase.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'model/time_entry.dart';

class SetTime extends StatefulWidget {
  SetTime({Key key}) : super(key: key);

  _SetState createState() => _SetState();
}


String userid = FirebaseAuth.instance.currentUser.uid;

DatabaseReference drugAdb1 = FirebaseDatabase.instance
    .reference()
    .child("device")
    .child(GetDeviceID.getDeviceID)
    .child("drugA");

class _SetState extends State<SetTime> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  DatabaseReference mainReference = FirebaseDatabase.instance.reference();

  DatabaseReference drugAdb;
  DatabaseReference drugBdb;

  int count;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification:
            onSelectNotification); //此行負責當我們單擊通知時將要發生的操作。此方法必須返回Future，並且此方法必須具有將成爲有效負載的字符串參數。

    mainReference = FirebaseDatabase.instance
        .reference()
        .child("device")
        .child(GetDeviceID.getDeviceID);
    drugAdb = mainReference.child("drugA");
    drugBdb = mainReference.child("drugB");
    flutterLocalNotificationsPlugin.cancelAll();
  }

  _SetState() {
    mainReference.onChildAdded.listen(_onEntryAdded);
    mainReference.onChildChanged.listen(_onEntryEdited);
  }

  @override //當 State 對象的關係發生變化時，這個方法總會被呼叫。
  void didChangeDependencies() {
    userid = FirebaseAuth.instance.currentUser.uid;
    super.didChangeDependencies();
  }

  List<DrugARealtime> drugASaves = new List();
  List<DrugBRealtime> drugBSaves = new List();

  Widget build(BuildContext context) {
    final drugA = Ink(
      width: MediaQuery.of(context).size.width / 2.0,
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
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
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
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        String nickName = snapshot.value['nickName'];
                        String drugName = snapshot.value['drugText'];
                        DateTime fromDate1 =
                            (DateTime.parse(snapshot.value['fromDate1']));
                        DateTime fromDate2;
                        DateTime fromDate3;
                        // DateTime time1 = new DateFormat('H:mm:s').parse(snapshot.value['fromDate1']);
                        if (snapshot.value['fromDate2'] != null) {
                          fromDate2 =
                              (DateTime.parse(snapshot.value['fromDate2']));
                        }
                        if (snapshot.value['fromDate3'] != null) {
                          fromDate3 =
                              (DateTime.parse(snapshot.value['fromDate3']));
                        }
                        List<DateTime> allDateTime = [];
                        if (fromDate1 != null &&
                            fromDate2 == null &&
                            fromDate2 == null) {
                          allDateTime.add(fromDate1);
                          allDateTime.removeWhere((value) => value == null);
                          allDateTime.sort((a, b) => a.compareTo(b));
                        }
                        if (fromDate1 != null &&
                            fromDate2 != null &&
                            fromDate2 == null) {
                          allDateTime.add(fromDate1);
                          allDateTime.add(fromDate2);
                          allDateTime.removeWhere((value) => value == null);
                          allDateTime.sort((a, b) => a.compareTo(b));
                        }
                        if (fromDate1 != null &&
                            fromDate2 != null &&
                            fromDate2 != null) {
                          allDateTime.add(fromDate1);
                          allDateTime.add(fromDate2);
                          allDateTime.add(fromDate3);
                          allDateTime.removeWhere((value) => value == null);
                          allDateTime.sort((a, b) => a.compareTo(b));
                        }

                        DateTime toDate =
                            (DateTime.parse(snapshot.value['toDate']));
                        String timeOfDay1 = snapshot.value['time1'];
                        String timeOfDay2 = snapshot.value['time2'];
                        String timeOfDay3 = snapshot.value['time3'];
                        int notificationId1 = snapshot.value['notificationId1'];
                        int notificationId2 = snapshot.value['notificationId2'];
                        int notificationId3 = snapshot.value['notificationId3'];
                        String active = snapshot.value['active'].toString();
                        String showDrugName;
                        if (nickName.isEmpty ||
                            nickName == null ||
                            nickName == "") {
                          showDrugName = drugName;
                        } else {
                          showDrugName = nickName;
                        }

                        if (active.isEmpty ||
                            active == null ||
                            active == "" ||
                            active == "null") {
                          if (notificationId1 != null) {
                            displayNotificationA(notificationId1, showDrugName,
                                "尚未取藥", fromDate1);
                          }
                          if (notificationId1 != null &&
                                  notificationId2 != null ||
                              active != "null") {
                            displayNotificationA(notificationId1, showDrugName,
                                "尚未取藥", fromDate1);
                            displayNotificationA(notificationId2, showDrugName,
                                "尚未取藥", fromDate2);
                          }
                          if (notificationId1 != null &&
                              notificationId2 != null &&
                              notificationId3 != null) {
                            displayNotificationA(notificationId1, showDrugName,
                                "尚未取藥", fromDate1);
                            displayNotificationA(notificationId2, showDrugName,
                                "尚未取藥", fromDate2);
                            displayNotificationA(notificationId3, showDrugName,
                                "尚未取藥", fromDate3);
                          }
                        } else if (active.isNotEmpty ||
                            active != null ||
                            active != "") {
                          print("已拿取");
                        }

                        DateTime now = DateTime.now();
                        if (now.isAfter(toDate)) {
                          deleteData(drugAdb);
                          print("結束日期已到");
                        }

                        return new InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditDrugA(),
                            ),
                          ),
                          child: Column(
                            children: [
                              new Text(
                                "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 5,
                                ),
                              ),
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
                                            fontSize: 22,
                                          ),
                                        ),
                                        new Text(
                                          drugName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 22,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        new Text(
                                          "藥品暱稱  ：",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 24,
                                          ),
                                        ),
                                        new Text(
                                          nickName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                              new Text(
                                "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new Text(
                                    "開始日期 ：",
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                  new Text(
                                    DateFormat('yyyy年MM月dd日').format(fromDate1),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new Text(
                                    "結束日期 ：",
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                  new Text(
                                    DateFormat('yyyy年MM月dd日').format(toDate),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                              new Text(
                                "       ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new Text(
                                    "設定時間 ：",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      if (allDateTime.length == 1) ...[
                                        Container(
                                          child: new Text(
                                            DateFormat()
                                                    .add_jm()
                                                    .format(allDateTime[0]) ??
                                                "",
                                            style: TextStyle(fontSize: 24),
                                          ), //設定畫面的時間
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ] else if (allDateTime.length == 2) ...[
                                        Container(
                                          child: new Text(
                                            DateFormat()
                                                .add_jm()
                                                .format(allDateTime[0]) ??
                                                "",
                                            style: TextStyle(fontSize: 24),
                                          ), //設定畫面的時間
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: new Text(
                                            DateFormat()
                                                    .add_jm()
                                                    .format(allDateTime[1]) ??
                                                "",
                                            style: TextStyle(fontSize: 24),
                                          ), //設定畫面的時間
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ] else if (allDateTime.length == 3) ...[
                                        Container(
                                          child: new Text(
                                            DateFormat()
                                                .add_jm()
                                                .format(allDateTime[0]) ??
                                                "",
                                            style: TextStyle(fontSize: 24),
                                          ), //設定畫面的時間
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: new Text(
                                            DateFormat()
                                                .add_jm()
                                                .format(allDateTime[1]) ??
                                                "",
                                            style: TextStyle(fontSize: 24),
                                          ), //設定畫面的時間
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                       Container(
                                          child: new Text(
                                            DateFormat()
                                                    .add_jm()
                                                    .format(allDateTime[2]) ??
                                                "",
                                            style: TextStyle(fontSize: 24),
                                          ), //設定畫面的時間
                                        ),
                                      ]
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return new InkWell(
                      splashColor: Colors.white24,
                      onTap: () => _openAddADialog(),
                      child: SizedBox(
                          width: 300,
                          height: 350,
                          child: Icon(Icons.add, size: 40.0)),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );

    final drugB = Ink(
      width: MediaQuery.of(context).size.width / 2.0,
      height: MediaQuery.of(context).size.height / 2.0,
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
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: StreamBuilder(
                stream: StaticInfo.readItemsB(),
                builder: (context, AsyncSnapshot<Event> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong'); //若連不上firestore會顯示
                  }
                  if (snapshot.hasData &&
                      snapshot.data.snapshot.value != null) {
                    return FirebaseAnimatedList(
                      query: drugBdb,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        String nickName = snapshot.value['nickName'];
                        String drugName = snapshot.value['drugText'];
                        DateTime fromDate1 =
                            (DateTime.parse(snapshot.value['fromDate1']));
                        DateTime fromDate2;
                        DateTime fromDate3;
                        // DateTime time1 = new DateFormat('H:mm:s').parse(snapshot.value['fromDate1']);
                        if (snapshot.value['fromDate2'] != null) {
                          fromDate2 =
                              (DateTime.parse(snapshot.value['fromDate2']));
                        }
                        if (snapshot.value['fromDate3'] != null) {
                          fromDate3 =
                              (DateTime.parse(snapshot.value['fromDate3']));
                        }
                        List<DateTime> allDateTime = [];
                        if (fromDate1 != null &&
                            fromDate2 == null &&
                            fromDate2 == null) {
                          allDateTime.add(fromDate1);
                          allDateTime.removeWhere((value) => value == null);
                          allDateTime.sort((a, b) => a.compareTo(b));
                        }
                        if (fromDate1 != null &&
                            fromDate2 != null &&
                            fromDate2 == null) {
                          allDateTime.add(fromDate1);
                          allDateTime.add(fromDate2);
                          allDateTime.removeWhere((value) => value == null);
                          allDateTime.sort((a, b) => a.compareTo(b));
                        }
                        if (fromDate1 != null &&
                            fromDate2 != null &&
                            fromDate2 != null) {
                          allDateTime.add(fromDate1);
                          allDateTime.add(fromDate2);
                          allDateTime.add(fromDate3);
                          allDateTime.removeWhere((value) => value == null);
                          allDateTime.sort((a, b) => a.compareTo(b));
                        }


                        DateTime toDate =
                            (DateTime.parse(snapshot.value['toDate']));
                        String timeOfDay1 = snapshot.value['time1'];
                        String timeOfDay2 = snapshot.value['time2'];
                        String timeOfDay3 = snapshot.value['time3'];
                        int notificationId1 = snapshot.value['notificationId1'];
                        int notificationId2 = snapshot.value['notificationId2'];
                        int notificationId3 = snapshot.value['notificationId3'];
                        String active = snapshot.value['active'].toString();
                        String showDrugName;
                        if (nickName.isEmpty ||
                            nickName == null ||
                            nickName == "") {
                          showDrugName = drugName;
                        } else {
                          showDrugName = nickName;
                        }

                        if (active.isEmpty ||
                            active == null ||
                            active == "" ||
                            active == "null") {
                          if (notificationId1 != null) {
                            displayNotificationB(notificationId1, showDrugName,
                                "尚未取藥", fromDate1);
                          }
                          if (notificationId1 != null &&
                                  notificationId2 != null ||
                              active != "null") {
                            displayNotificationB(notificationId1, showDrugName,
                                "尚未取藥", fromDate1);
                            displayNotificationB(notificationId2, showDrugName,
                                "尚未取藥", fromDate2);
                          }
                          if (notificationId1 != null &&
                              notificationId2 != null &&
                              notificationId3 != null) {
                            displayNotificationB(notificationId1, showDrugName,
                                "尚未取藥", fromDate1);
                            displayNotificationB(notificationId2, showDrugName,
                                "尚未取藥", fromDate2);
                            displayNotificationB(notificationId3, showDrugName,
                                "尚未取藥", fromDate3);
                          }
                        } else if (active.isNotEmpty ||
                            active != null ||
                            active != "") {
                          print("已拿取");
                        }
                        if (timeOfDay1 == "null") {
                          CheckTime.time1bCheck = true;
                        }
                        if (timeOfDay2 != "null" || timeOfDay2 != null) {
                          CheckTime.time2bCheck = true;
                        }
                        if (timeOfDay3 != "null" || timeOfDay3 != null) {
                          CheckTime.time3bCheck = true;
                        }
                        DateTime now = DateTime.now();
                        if (now.isAfter(toDate)) {
                          deleteData(drugBdb);
                          print("結束日期已到");
                        }

                        return new InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditDrugB(),
                            ),
                          ),
                          child: Column(
                            children: [
                              new Text(
                                "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 5,
                                ),
                              ),
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
                                            fontSize: 22,
                                          ),
                                        ),
                                        new Text(
                                          drugName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 22,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        new Text(
                                          "藥品暱稱  ：",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 24,
                                          ),
                                        ),
                                        new Text(
                                          nickName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                              new Text(
                                "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new Text(
                                    "開始日期 ：",
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                  new Text(
                                    DateFormat('yyyy年MM月dd日').format(fromDate1),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new Text(
                                    "結束日期 ：",
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                  new Text(
                                    DateFormat('yyyy年MM月dd日').format(toDate),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                ],
                              ),
                              new Text(
                                "       ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new Text(
                                    "設定時間 ：",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      if (allDateTime.length == 1) ...[
                                        Container(
                                          child: new Text(
                                            DateFormat()
                                                .add_jm()
                                                .format(allDateTime[0]) ??
                                                "",
                                            style: TextStyle(fontSize: 24),
                                          ), //設定畫面的時間
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ] else if (allDateTime.length == 2) ...[
                                        Container(
                                          child: new Text(
                                            DateFormat()
                                                .add_jm()
                                                .format(allDateTime[0]) ??
                                                "",
                                            style: TextStyle(fontSize: 24),
                                          ), //設定畫面的時間
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: new Text(
                                            DateFormat()
                                                .add_jm()
                                                .format(allDateTime[1]) ??
                                                "",
                                            style: TextStyle(fontSize: 24),
                                          ), //設定畫面的時間
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ] else if (allDateTime.length == 3) ...[
                                        Container(
                                          child: new Text(
                                            DateFormat()
                                                .add_jm()
                                                .format(allDateTime[0]) ??
                                                "",
                                            style: TextStyle(fontSize: 24),
                                          ), //設定畫面的時間
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: new Text(
                                            DateFormat()
                                                .add_jm()
                                                .format(allDateTime[1]) ??
                                                "",
                                            style: TextStyle(fontSize: 24),
                                          ), //設定畫面的時間
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          child: new Text(
                                            DateFormat()
                                                .add_jm()
                                                .format(allDateTime[2]) ??
                                                "",
                                            style: TextStyle(fontSize: 24),
                                          ), //設定畫面的時間
                                        ),
                                      ]
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return new InkWell(
                      splashColor: Colors.white24,
                      onTap: () => _openAddBDialog(),
                      child: SizedBox(
                          width: 300,
                          height: 350,
                          child: Icon(Icons.add, size: 40.0)),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   backgroundColor: Color.fromRGBO(210, 180, 140, 1.0),
      //   onPressed: _openAddEntryDialog,
      // ),
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
        ),
      ),
    );
  }

  Future _openAddADialog() async {
    DrugARealtime entryA = await Navigator.of(context).push(
        new MaterialPageRoute<DrugARealtime>(
            builder: (context) => AddDrugA(), fullscreenDialog: true));
    if (entryA != null) {
      mainReference.push().set(entryA.toJson());
    }
  }

  Future _openAddBDialog() async {
    DrugBRealtime entryB = await Navigator.of(context).push(
        new MaterialPageRoute<DrugBRealtime>(
            builder: (context) => AddDrugB(), fullscreenDialog: true));
    if (entryB != null) {
      mainReference.push().set(entryB.toJson());
    }
  }

  _onEntryAdded(Event event) {
    if (!mounted) return; ////
    setState(() {
      userid = FirebaseAuth.instance.currentUser.uid;
      drugASaves.add(new DrugARealtime.fromSnapshot(event.snapshot));
      drugASaves
          .sort((we1, we2) => we1.fromDateTime.compareTo(we2.fromDateTime));

      drugBSaves.add(new DrugBRealtime.fromSnapshot(event.snapshot));
      drugBSaves
          .sort((we1, we2) => we1.fromDateTime.compareTo(we2.fromDateTime));
    });
    drugAdb1.onValue;
  }

  _onEntryEdited(Event event) {
    if (!mounted) return; ////
    var oldAValue =
        drugASaves.singleWhere((entry) => entry.key == event.snapshot.key);
    var oldBValue =
        drugBSaves.singleWhere((entry) => entry.key == event.snapshot.key);
    var oldCValue = setState(() {
      userid = FirebaseAuth.instance.currentUser.uid;
      drugASaves[drugASaves.indexOf(oldAValue)] =
          new DrugARealtime.fromSnapshot(event.snapshot);
      drugASaves
          .sort((we1, we2) => we1.fromDateTime.compareTo(we2.fromDateTime));

      drugBSaves[drugBSaves.indexOf(oldBValue)] =
          new DrugBRealtime.fromSnapshot(event.snapshot);
      drugBSaves
          .sort((we1, we2) => we2.fromDateTime.compareTo(we1.fromDateTime));
    });
    drugAdb1.onValue;
  }

  Future initializetimezone() async {
    tz.initializeTimeZones();
  }

  Future<void> displayNotificationA(
      int notificationId, String title, String body, DateTime dateTime) async {
    await initializetimezone();

    var iosDetail = IOSNotificationDetails();
    var androidDetails = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription',
        fullScreenIntent: true,
        priority: Priority.high,
        importance: Importance.high);

    var platFormDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetail);

    flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        tz.TZDateTime.from(dateTime.add(const Duration(minutes: 30)), tz.local),
        platFormDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  Future<void> displayNotificationB(
      int notificationId, String title, String body, DateTime dateTime) async {
    await initializetimezone();

    var iosDetail = IOSNotificationDetails();
    var androidDetails = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription',
        fullScreenIntent: true,
        priority: Priority.high,
        importance: Importance.high);

    var platFormDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetail);

    flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        body,
        tz.TZDateTime.from(dateTime.add(const Duration(minutes: 30)), tz.local),
        platFormDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  Future<void> cancelNotification(int notifId) async {
    notifId = count;

    await flutterLocalNotificationsPlugin.cancel(notifId); //notifId 爲需要刪除的通知的id
  }

  Future onSelectNotification(String notifId) async {
    await cancelNotification(int.parse(notifId));
    print("結束通知");
    return "Notif canceled";
  }
}

class CheckTime {
  static bool time1aCheck = true;
  static bool time2aCheck = false;
  static bool time3aCheck = false;

  static bool time1bCheck = true;
  static bool time2bCheck = false;
  static bool time3bCheck = false;
}

Future<void> deleteData(DatabaseReference databaseReference) {
  databaseReference.remove();
}

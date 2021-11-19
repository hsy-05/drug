//當按下Home按鈕時，出現的介面
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/authHome/time_content/edit_time_form.dart';
import 'package:flutter1/authHome/time_content/list_item.dart';
import 'package:flutter1/authHome/time_content/add_time_form.dart';
import 'package:flutter1/authHome/time_content/screens/add_drugA.dart';
import 'package:flutter1/authHome/time_content/screens/add_drugB.dart';
import 'package:flutter1/authHome/time_content/screens/add_drugC.dart';
import 'package:flutter1/authHome/time_content/screens/add_drugD.dart';
import 'package:flutter1/authHome/time_content/screens/edit_drugA.dart';
import 'package:flutter1/authHome/time_content/screens/edit_drugB.dart';
import 'package:flutter1/authHome/time_content/screens/edit_drugC.dart';
import 'package:flutter1/authHome/time_content/screens/edit_drugD.dart';
import 'package:flutter1/authHome/time_content/screens/edit_time.dart';
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

DatabaseReference mainReference = FirebaseDatabase.instance.reference();
DatabaseReference drugAdb;
DatabaseReference drugBdb;
DatabaseReference drugCdb;
DatabaseReference drugDdb;
String userid = FirebaseAuth.instance.currentUser.uid;

class _SetState extends State<SetTime> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  int count;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);

    mainReference = FirebaseDatabase.instance.reference().child("device").child(userid);
    drugAdb = mainReference.child("drugA");
    drugBdb = mainReference.child("drugB");
    drugCdb = mainReference.child("drugC");
    drugDdb = mainReference.child("drugD");
  }


  _SetState() {
    mainReference.onChildAdded.listen(_onEntryAdded);
    mainReference.onChildChanged.listen(_onEntryEdited);
  }

  @override       //當 State 對象的關係發生變化時，這個方法總會被呼叫。
  void didChangeDependencies() {
    userid = FirebaseAuth.instance.currentUser.uid;
    super.didChangeDependencies();

  }

  List<DrugARealtime> drugASaves = new List();
  List<DrugBRealtime> drugBSaves = new List();
  List<DrugCRealtime> drugCSaves = new List();
  List<DrugDRealtime> drugDSaves = new List();

  Widget build(BuildContext context) {
    final drugA = Ink(
      color: Color.fromRGBO(210, 180, 140, 1.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: StreamBuilder(
                stream: StaticInfo.readItems(),
                builder: (context, AsyncSnapshot<Event> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong'); //若連不上realtime會顯示
                  }
                  else if (snapshot.hasData &&
                      snapshot.data.snapshot.value != null) {
                    return FirebaseAnimatedList(
                      query: drugAdb,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        String drugName = snapshot.value['drugText'];
                        print("藥品名稱："+drugName);
                        DateTime fromDate =
                        (DateTime.parse(snapshot.value['fromDate']));
                        DateTime toDate =
                        (DateTime.parse(snapshot.value['toDate']));
                        int notificationId = snapshot.value['notificationId'];
                        displayNotification(
                            notificationId, drugName, "已過半小時尚未取藥", fromDate);

                        return new InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditDrugA(),
                            ),
                          ),
                          child: Column(
                            children: [
                              new Text(
                                "藥品名稱：",
                                textAlign: TextAlign.left,
                              ),
                              new Text(
                                snapshot.value['drugText'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Row(
                                children: [
                                  new Text("開始日期 ："),
                                  new Text(
                                    DateFormat('yyyy-MM-dd').format(fromDate),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  new Text("結束日期 ："),
                                  new Text(
                                    DateFormat('yyyy-MM-dd').format(toDate),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  new Text("設定時間 ："),
                                  Column(
                                    children: [
                                      new Text(
                                        DateFormat().add_jm().format(fromDate),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      new Text(
                                        DateFormat().add_jm().format(fromDate),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      new Text(
                                        DateFormat().add_jm().format(fromDate),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
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
                          width: 100, height: 100, child: Icon(Icons.add)),
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
      color: Color.fromRGBO(210, 180, 140, 1.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: StreamBuilder(
                stream: StaticInfo.readItems1(),
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
                        String drugName = snapshot.value['drugText'];
                        DateTime fromDate =
                        (DateTime.parse(snapshot.value['fromDate']));
                        DateTime toDate =
                        (DateTime.parse(snapshot.value['toDate']));
                        int notificationId = snapshot.value['notificationId'];
                        displayNotification(
                            notificationId, drugName, "以過半小時尚未取藥", fromDate);

                        return new InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditDrugB(),
                            ),
                          ),
                          child: Column(
                            children: [
                              new Text(
                                "藥品名稱：",
                                textAlign: TextAlign.left,
                              ),
                              new Text(
                                snapshot.value['drugText'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Row(
                                children: [
                                  new Text("開始日期："),
                                  new Text(
                                    DateFormat('yyyy-MM-dd').format(fromDate),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  new Text("結束日期："),
                                  new Text(
                                    DateFormat('yyyy-MM-dd').format(toDate),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  new Text("設定時間："),
                                  new Text(
                                    DateFormat().add_jm().format(fromDate),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
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
                          width: 100, height: 100, child: Icon(Icons.add)),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );

    final drugC = Ink(
      color: Color.fromRGBO(210, 180, 140, 1.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: StreamBuilder(
                stream: StaticInfo.readItems2(),
                builder: (context, AsyncSnapshot<Event> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong'); //若連不上firestore會顯示
                  }
                  if (snapshot.hasData &&
                      snapshot.data.snapshot.value != null) {
                    return FirebaseAnimatedList(
                      query: drugCdb,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        String drugName = snapshot.value['drugText'];
                        DateTime fromDate =
                        (DateTime.parse(snapshot.value['fromDate']));
                        DateTime toDate =
                        (DateTime.parse(snapshot.value['toDate']));
                        int notificationId = snapshot.value['notificationId'];
                        displayNotification(
                            notificationId, drugName, "以過半小時尚未取藥", fromDate);

                        return new InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditDrugC(),
                            ),
                          ),
                          child: Column(
                            children: [
                              new Text(
                                "藥品名稱：",
                                textAlign: TextAlign.left,
                              ),
                              new Text(
                                snapshot.value['drugText'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Row(
                                children: [
                                  new Text("開始日期："),
                                  new Text(
                                    DateFormat('yyyy-MM-dd').format(fromDate),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  new Text("結束日期："),
                                  new Text(
                                    DateFormat('yyyy-MM-dd').format(toDate),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  new Text("設定時間："),
                                  new Text(
                                    DateFormat().add_jm().format(fromDate),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
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
                      onTap: () => _openAddCDialog(),
                      child: SizedBox(
                          width: 100, height: 100, child: Icon(Icons.add)),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );

    final drugD = Ink(
      color: Color.fromRGBO(210, 180, 140, 1.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: StreamBuilder(
                stream: StaticInfo.readItems3(),
                builder: (context, AsyncSnapshot<Event> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong'); //若連不上firestore會顯示
                  }
                  if (snapshot.hasData &&
                      snapshot.data.snapshot.value != null) {
                    return FirebaseAnimatedList(
                      query: drugDdb,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        String drugName = snapshot.value['drugText'];
                        DateTime fromDate =
                        (DateTime.parse(snapshot.value['fromDate']));
                        DateTime toDate =
                        (DateTime.parse(snapshot.value['toDate']));
                        int notificationId = snapshot.value['notificationId'];
                        displayNotification(
                            notificationId, drugName, "以過半小時尚未取藥", fromDate);

                        return new InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditDrugD(),
                            ),
                          ),
                          child: Column(
                            children: [
                              new Text(
                                "藥品名稱：",
                                textAlign: TextAlign.left,
                              ),
                              new Text(
                                snapshot.value['drugText'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              Row(
                                children: [
                                  new Text("開始日期："),
                                  new Text(
                                    DateFormat('yyyy-MM-dd').format(fromDate),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  new Text("結束日期："),
                                  new Text(
                                    DateFormat('yyyy-MM-dd').format(toDate),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  new Text("設定時間："),
                                  new Text(
                                    DateFormat().add_jm().format(fromDate),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
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
                      onTap: () => _openAddDDialog(),
                      child: SizedBox(
                          width: 100, height: 100, child: Icon(Icons.add)),
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
        //每個List的顯示
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 8,
              childAspectRatio: 0.65,
            ),
            children: [
              drugA,
              drugB,
              drugC,
              drugD,
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

  Future _openAddCDialog() async {
    DrugCRealtime entryC = await Navigator.of(context).push(
        new MaterialPageRoute<DrugCRealtime>(
            builder: (context) => AddDrugC(), fullscreenDialog: true));
    if (entryC != null) {
      mainReference.push().set(entryC.toJson());
    }
  }

  Future _openAddDDialog() async {
    DrugDRealtime entryD = await Navigator.of(context).push(
        new MaterialPageRoute<DrugDRealtime>(
            builder: (context) => AddDrugD(), fullscreenDialog: true));
    if (entryD != null) {
      mainReference.push().set(entryD.toJson());
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

      drugCSaves.add(new DrugCRealtime.fromSnapshot(event.snapshot));
      drugCSaves
          .sort((we1, we2) => we1.fromDateTime.compareTo(we2.fromDateTime));
      drugDSaves.add(new DrugDRealtime.fromSnapshot(event.snapshot));
      drugDSaves
          .sort((we1, we2) => we1.fromDateTime.compareTo(we2.fromDateTime));
    });
  }

  _onEntryEdited(Event event) {
    if (!mounted) return; ////
    var oldAValue =
    drugASaves.singleWhere((entry) => entry.key == event.snapshot.key);
    var oldBValue =
    drugBSaves.singleWhere((entry) => entry.key == event.snapshot.key);
    var oldCValue =
    drugCSaves.singleWhere((entry) => entry.key == event.snapshot.key);
    var oldDValue =
    drugDSaves.singleWhere((entry) => entry.key == event.snapshot.key);

    setState(() {
      userid = FirebaseAuth.instance.currentUser.uid;
      drugASaves[drugASaves.indexOf(oldAValue)] =
      new DrugARealtime.fromSnapshot(event.snapshot);
      drugASaves
          .sort((we1, we2) => we1.fromDateTime.compareTo(we2.fromDateTime));

      drugBSaves[drugBSaves.indexOf(oldBValue)] =
      new DrugBRealtime.fromSnapshot(event.snapshot);
      drugBSaves
          .sort((we1, we2) => we1.fromDateTime.compareTo(we2.fromDateTime));

      drugCSaves[drugCSaves.indexOf(oldCValue)] =
      new DrugCRealtime.fromSnapshot(event.snapshot);
      drugCSaves
          .sort((we1, we2) => we1.fromDateTime.compareTo(we2.fromDateTime));
      drugDSaves[drugDSaves.indexOf(oldDValue)] =
      new DrugDRealtime.fromSnapshot(event.snapshot);
      drugDSaves
          .sort((we1, we2) => we1.fromDateTime.compareTo(we2.fromDateTime));
    });
  }

  Future initializetimezone() async {
    tz.initializeTimeZones();
  }

  Future<void> displayNotification(
      int notificationId, String title, String body, DateTime dateTime) async {
    await initializetimezone();

    var androidDetails = AndroidNotificationDetails(
        '1', 'Tasks', 'Reminders of Tasks',
        fullScreenIntent: true,
        priority: Priority.high,
        importance: Importance.high);

    var platFormDetails = NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.zonedSchedule(notificationId, title, body,
        tz.TZDateTime.from(dateTime, tz.local), platFormDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }


  Future<void> cancelNotification(int notifId) async {
    notifId = count;

    await flutterLocalNotificationsPlugin.cancel(notifId);//notifId 爲需要刪除的通知的id
  }

  Future onSelectNotification(String notifId) async {
    await cancelNotification(int.parse(notifId));
    print("結束通知");
    return "Notif canceled";
  }
}

//當按下Home按鈕時，出現的介面
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/authHome/time_content/edit_time_form.dart';
import 'package:flutter1/authHome/time_content/list_item.dart';
import 'package:flutter1/authHome/time_content/add_time_form.dart';
import 'package:flutter1/authHome/time_content/screens/edit_time.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:flutter1/authHome/model/time_firebase.dart';
import 'package:timezone/timezone.dart' as tz;

class SetTime extends StatefulWidget {
  SetTime({Key key}) : super(key: key);
  _SetState createState() => _SetState();
}

class _SetState extends State<SetTime> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }


  Future<void> cancelNotification(int notifId) async {
    await flutterLocalNotificationsPlugin.cancel(notifId);
  }

  Future onSelectNotification(String notifId) async {
    await cancelNotification(int.parse(notifId));
    print("Notif canceled");
    return "Notif canceled";
  }

  Widget build(BuildContext context) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Color.fromRGBO(210, 180, 140, 1.0),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddForm(),
              ),
            );
          },
        ),
        body: SafeArea(     //每個List的顯示
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: StreamBuilder<QuerySnapshot>(
          stream: Entry.readItems(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong'); //若連不上firestore會顯示
            } else if (snapshot.hasData || snapshot.data != null) {
              return ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 16.0),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  var noteInfo = snapshot.data.docs[index].data();
                  String docID = snapshot.data.docs[index].id;
                  String drugname = noteInfo['drugName'];
                  DateTime time =  noteInfo['fromDate'].toDate();
                  int notificationId = noteInfo['notificationId'];
                  // String dateString = DateFormat('yyyy - MM - dd hh:mm').format(time);
                  displayNotification(notificationId , drugname,
                      "以過半小時尚未取藥", time);
                  return Ink(
                    decoration: BoxDecoration(
                      //list的眶
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: SizedBox(
                      height: 100,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditItemForm(
                              currentTitle: DateFormat('yyyy年 MM月 dd日').add_jm().format(time), // DateFormat('yyyy年 MM月 dd日 hh:mm').format(time),//
                              documentId: docID,
                            ),
                          ),
                        ),
                        title: Text(
                          drugname ?? "",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            DateFormat('yyyy年 MM月 dd日').add_jm().format(time),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            // overflow: TextOverflow.ellipsis,
                            // textAlign: TextAlign.right,
                          ),
                        ),
                        trailing: Switch(
                            value: noteInfo['active'] == 1,
                            onChanged: (changingStatus) {
                              // Toogle the status of the alarm clock first
                              if (noteInfo['active'] == 1)
                                noteInfo['active'] = 0;
                              else
                                noteInfo['active'] = 1;

                              // // Save the new status in the database
                              // this._alarmDatabase.updateAlarm(allAlarmClocks[index]);
                            }),
                      ),
                    ),
                  );
                },
              );
            }

            return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(204, 119, 34, 1.0),),
                )
            );
          },
        ),
          ),
        ),
      );
  }

  Future<void> displayNotification(
      int notificationId, String title, String body, DateTime dateTime) async {
    var androidDetails = AndroidNotificationDetails(
        '1',
        'Tasks',
        'Reminders of Tasks',
        fullScreenIntent: true,
        priority: Priority.high,
        importance: Importance.high);

    var platFormDetails = NotificationDetails(android: androidDetails);

      flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId,
          title,
          body,
          tz.TZDateTime.from(dateTime, tz.local),
          platFormDetails,

          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true);
  }
}
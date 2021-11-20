import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter1/authHome/model/time_entry.dart';
import 'package:flutter1/authHome/set_time.dart';



// Future<bool> _deviceIDDB (String code) async {
// /// return true if no room with given code has been found in db
// return await deviceIDDB.child('deviceID')
// .once()
//     .then((snapshot) => snapshot.value == null);
// }
DatabaseReference users;
DatabaseReference devices;

@override
void initState() {
  users = FirebaseDatabase.instance.reference().child("users");
  devices = FirebaseDatabase.instance.reference().child("devices");
}

Future<String> inputDeviceID(BuildContext context) async {

  String inputData = '';
  return showDialog<String>(
    context: context,
    barrierDismissible: false, //控制點擊對話框以外的區域是否隱藏對話框
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('請輸入裝置ID'),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextField(
              autofocus: true,
              decoration: new InputDecoration(hintText: '請輸入裝置ID...'),
              onChanged: (value) {
                inputData = value;
              },
            ))
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('送出'),
            onPressed: () {
              Navigator.of(context).pop(inputData);
            },
          ),
        ],
      );
    },
  );
}

class GetDeviceID{
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  static String getDeviceID;

  Future<String> getd() async {
    await databaseReference
        .child('users').child(StaticInfo.userid)
        .once().then((DataSnapshot snapshot) {
      getDeviceID = snapshot.value['device_id'];
      return getDeviceID;
    });
  }
}

//
// void checkDeviceID() async{
//   dynamic allDevice;
//   devices.once().then((DataSnapshot snapshot){         //查詢devices裡所有的device_id
//     Map<dynamic, dynamic> values = snapshot.value;
//     values.forEach((key,values) {
//       allDevice = values["device_id"];
//       var childKey = key;
//       print(values["device_id"]);
//       print("childID名稱：");
//       print(childKey);
//     });
//   });
//
//   DataSnapshot userSnap = await users.reference().child(StaticInfo.userid).once();   //查詢users裡的device_id
//   dynamic userDevice = userSnap.value['device_id'];
//   print("userDevice：");
//   print(userDevice);
//
//   if (allDevice == userDevice){
//     devices.reference().child("AP7Kk").update({
//       "status": "T",
//     });
//     print("狀態已更改");
//   }
// }


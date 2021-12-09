import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter1/helpers/device_input.dart';

class GetDrugTimes {
  DatabaseReference mainReference = FirebaseDatabase.instance.reference();


  List<int> getDrugATimesList = [];
  List<int> getDrugBTimesList = [];

  Future<List> drugTimes()  {

    TimeOfDay n = TimeOfDay.now();
    int _endTime = new DateTime.now().millisecondsSinceEpoch;
    mainReference
        .child("device").child(GetDeviceID.getDeviceID).child("drugA")
        .once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        String drugName = snapshot.value['drugText'];
        String timeStringA1 =values['time1'];
        String timeStringA2 =values['time2'];
        String timeStringA3 =values['time3'];

        TimeOfDay timeA1 = TimeOfDay(hour:int.parse(timeStringA1.split(":")[0]),minute: int.parse(timeStringA1.split(":")[1]));

        TimeOfDay timeA2 = TimeOfDay(hour:int.parse(timeStringA2.split(":")[0]),minute: int.parse(timeStringA2.split(":")[1]));

        TimeOfDay timeA3 = TimeOfDay(hour:int.parse(timeStringA3.split(":")[0]),minute: int.parse(timeStringA3.split(":")[1]));

        int difhourA1 = Duration(hours: timeA1.hour - n.hour).inMilliseconds;
        int difminA1 = Duration(minutes: timeA1.minute - n.minute).inMilliseconds;
        int endTimeA1 = _endTime + difhourA1 + difminA1;

        int difhourA2 = Duration(hours: timeA2.hour - n.hour).inMilliseconds;
        int difminA2 = Duration(minutes: timeA2.minute - n.minute).inMilliseconds;
        int endTimeA2 = _endTime + difhourA2 + difminA2;

        int difhourA3 = Duration(hours: timeA3.hour - n.hour).inMilliseconds;
        int difminA3 = Duration(minutes: timeA3.minute - n.minute).inMilliseconds;
        int endTimeA3 = _endTime + difhourA3 + difminA3;

        getDrugATimesList.add(endTimeA1);
        getDrugATimesList.add(endTimeA2);
        getDrugATimesList.add(endTimeA3);
        getDrugATimesList.removeWhere((value) => value == null);

        print("result");
        print(values);
        print("getDrugATimesList");
        print(getDrugATimesList);
      });
      values.forEach((key, v) {print("${v['drugText'].toString()} : ${v['time1'].toString()}, xyz : ${v['xyz'].toString()}");
      });
    mainReference
        .child("device").child(GetDeviceID.getDeviceID).child("drugB")
        .once().then((DataSnapshot snapshot) {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {
        TimeOfDay timeB1;
        TimeOfDay timeB2;
        TimeOfDay timeB3;
        int endTimeB1;
        int endTimeB2;
        int endTimeB3;

        if(values['time1'] != null){
          String timeStringB1 =values['time1'];
          timeB1 = TimeOfDay(hour:int.parse(timeStringB1.split(":")[0]),minute: int.parse(timeStringB1.split(":")[1]));

          int difhourB1 = Duration(hours: timeB1.hour - n.hour).inMilliseconds;
          int difminB1 = Duration(minutes: timeB1.minute - n.minute).inMilliseconds;
          endTimeB1 = _endTime + difhourB1 + difminB1;
        }
        if(values['time2'] != null){
          String timeStringB2 =values['time2'];
          timeB2 = TimeOfDay(hour:int.parse(timeStringB2.split(":")[0]),minute: int.parse(timeStringB2.split(":")[1]));

          int difhourB2 = Duration(hours: timeB2.hour - n.hour).inMilliseconds;
          int difminB2 = Duration(minutes: timeB2.minute - n.minute).inMilliseconds;
          endTimeB2 = _endTime + difhourB2 + difminB2;
        }
        if(values['time3'] != null){
          String timeStringB3 =values['time3'];
          timeB3 = TimeOfDay(hour:int.parse(timeStringB3.split(":")[0]),minute: int.parse(timeStringB3.split(":")[1]));

          int difhourB3 = Duration(hours: timeB3.hour - n.hour).inMilliseconds;
          int difminB3 = Duration(minutes: timeB3.minute - n.minute).inMilliseconds;
          endTimeB3 = _endTime + difhourB3 + difminB3;

        }


        getDrugBTimesList.add(endTimeB1);
        getDrugBTimesList.add(endTimeB2);
        getDrugBTimesList.add(endTimeB3);
        getDrugBTimesList.removeWhere((value) => value == null);
        print("getDrugBTimesList");
        print(getDrugBTimesList);

        getDrugATimesList.addAll(getDrugBTimesList);
        getDrugATimesList.sort((a,b) => a.compareTo(b));
        print("getDrugATimesList.combine");
        print(getDrugATimesList);
        return getDrugATimesList;
      });
    });
    });


  }

}
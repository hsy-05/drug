//當按下Home按鈕時，出現的介面
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/helpers/device_input.dart';
import '../helpers/Constants.dart';
import 'package:firebase_database/firebase_database.dart';


class Record extends StatefulWidget {
  Record({Key key}) : super(key: key);

  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> {
  List<TimeRecord> timeRecordList = List();
  TimeRecord timeRecorditem;
  DatabaseReference recordRef;


  @override
  void initState() {
    super.initState();
    timeRecorditem = TimeRecord("", "", "");
    final FirebaseDatabase database = FirebaseDatabase
        .instance; //Rather then just writing FirebaseDatabase(), get the instance.
    recordRef = database.reference().child("drugRecord").child(GetDeviceID.getDeviceID);
    recordRef.onChildAdded.listen(_onEntryAdded);
  }


  _onEntryAdded(Event event) {
    if (!mounted) return; ////
    setState(() {
      timeRecordList.add(TimeRecord.fromSnapshot(event.snapshot));

    });
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children:[
          Flexible(
            child: FirebaseAnimatedList(
              //使用FirebaseAnimatedList控制元件把訊息列表顯示出來
              query: recordRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return ListTile(
                  //顯示全部
                  leading:  Icon(Icons.fiber_manual_record_outlined),
                  title:  Text(timeRecordList[index].drugText.toString(),style: TextStyle(fontSize: 18,),
                  ),
                  subtitle:Text(timeRecordList[index].re_date.toString(),style: TextStyle(fontSize: 18,),
                  ),
                    trailing:Text(timeRecordList[index].re_time.toString(),style: TextStyle(fontSize: 18,),
                    ),
                );
              },
            ),
          ),
        ]

      ),

    );
  }
}

class TimeRecord {
  String key;
  String drugText;
  String re_date;
  String re_time;

  TimeRecord(this.drugText, this.re_date, this.re_time);

  TimeRecord.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        drugText = snapshot.value["drugText"],
        re_date = snapshot.value["re_date"],
        re_time = snapshot.value["re_time"];

  toJson() {
    return {
      "drugText": drugText,
      "re_date": re_date,
      "re_time": re_time
    };
  }
}
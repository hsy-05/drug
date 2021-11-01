import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter1/authHome/model/time_entry.dart';
import 'package:intl/intl.dart';
import 'package:flutter1/authHome/model/time_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/authHome/time_content/screens/search.dart';
import 'package:flutter1/authHome/time_content/screens/med_mode.dart';

class AddDrugB extends StatefulWidget {

  @override
  _AddDrugBState createState() => _AddDrugBState();
}

class _AddDrugBState extends State<AddDrugB> {

  int active=1;
  String drugText;
  DateTime _fromDateTime = new DateTime.now();
  DateTime _toDateTime = new DateTime.now();
  TimeOfDay time = new TimeOfDay.now();
  TimeOfDay time1 = new TimeOfDay.now();
  TimeOfDay time2 = new TimeOfDay.now();

  DatabaseReference drugB;

  @override
  void initState() {
    super.initState();
    drugB = FirebaseDatabase.instance.reference().child("device").child(StaticInfo.userid).child("drugB");
  }


  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Color.fromRGBO(210, 180, 140, 1.0),
      actions: [
        new FlatButton(
          onPressed: () async {
            saveContact();
            // drugB.reference().push().set(drugText);
            Navigator.of(context).pop();
          },
          child: new Text('新增',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Colors.white, fontSize: 20.0)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _createAppBar(context),
      body: new Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            new ListTile(
              horizontalTitleGap: 10,
              minLeadingWidth: 0,
              onTap: (() => _showFromDatePicker(context)),
              leading: new Icon(Icons.today, size: 22),
              title: Text("開始日期", style: TextStyle(fontSize: 18)),
              trailing: Text(
                new DateFormat('yyyy年 MM月 dd日').format(_fromDateTime),//設定畫面的年月日
                style: TextStyle(fontSize: 18),
              ),
            ),

            new ListTile(
              horizontalTitleGap: 10,
              minLeadingWidth: 0,
              onTap: (() => _showToDatePicker(context)),
              leading: new Icon(Icons.today, size: 22),
              title: Text("結束日期", style: TextStyle(fontSize: 18)),
              trailing: Text(
                new DateFormat('yyyy年 MM月 dd日').format(_toDateTime),//設定畫面的年月日
                style: TextStyle(fontSize: 18),
              ),
            ),

            new ListTile(
              horizontalTitleGap: 10,
              minLeadingWidth: 0,
              leading: new Icon(Icons.search),
              title: Text(
                drugText ?? "新增藥品名稱",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                _returnValueOfDrugText(context);
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            new ListTile(
              title: Text(
                "服藥模式",
                style: TextStyle(fontSize: 18),
              ),
              onTap: () {
                _returnValueOfDrugTime(context);
              },
            ),
            new ListTile(
              title: Text(
                time.format(context),
                style: TextStyle(fontSize: 18),
              ),
            ),
            new ListTile(
              title: Text(
                time1.format(context),
                style: TextStyle(fontSize: 18),
              ),
            ),
            new ListTile(
              title: Text(
                time2.format(context),
                style: TextStyle(fontSize: 18),
              ),
            ),
          ]).toList(),
        ),
      ),
    );
  }

  void _returnValueOfDrugText(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchText(),
        ));

    setState(() {
      drugText = result;
    });
  }

  void _returnValueOfDrugTime(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicineMode(),
        ));
    // final result1 = await Navigator.of(context).push();
    setState(() {
      time = result[0];
      _fromDateTime = new DateTime(_fromDateTime.year, _fromDateTime.month,
          _fromDateTime.day, time.hour, time.minute);
      _toDateTime = new DateTime(_toDateTime.year, _toDateTime.month,
          _toDateTime.day, time.hour, time.minute);
      time1 = result[1];
      time2 = result[2];
    });
  }

  Future _showFromDatePicker(BuildContext context) async {
    DateTime dateTimePicked = await showDatePicker(
        context: context,
        initialDate: _fromDateTime,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Color.fromRGBO(210, 180, 140, 1.0),
                // header background color
                onPrimary: Colors.black,
                // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary:
                  Color.fromRGBO(204, 119, 34, 1.0), // button text color
                ),
              ),
            ),
            child: child,
          );
        },
        firstDate: _fromDateTime.subtract(const Duration(days: 20000)),
        lastDate: new DateTime(2033, 12, 31));

    if (dateTimePicked != null) {
      _fromDateTime = new DateTime(dateTimePicked.year, dateTimePicked.month,
          dateTimePicked.day, time.hour, time.minute);
      setState(() {
        _fromDateTime = dateTimePicked;
        // fromDate = dateTimePicked;
        // return fromDate;
      });
    }
  }

  Future _showToDatePicker (BuildContext context) async {
    DateTime dateTimePicked = await showDatePicker(
        context: context,
        initialDate: _toDateTime,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Color.fromRGBO(210, 180, 140, 1.0),
                // header background color
                onPrimary: Colors.black,
                // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary:
                  Color.fromRGBO(204, 119, 34, 1.0), // button text color
                ),
              ),
            ),
            child: child,
          );
        },
        firstDate: _toDateTime,
        lastDate: new DateTime(2033, 12, 31));

    if (dateTimePicked != null) {
      _toDateTime = new DateTime(dateTimePicked.year, dateTimePicked.month,
          dateTimePicked.day, time.hour, time.minute);
      setState(() {
        _toDateTime = dateTimePicked;
        // toDate = dateTimePicked;
        // return toDate;
      });
    }
  }


  void saveContact(){

    int notificationId = Random().nextInt(1000);

    var different = _toDateTime.difference(_fromDateTime).inDays;

    print("計算天數");
    print(different); // 19362

    Map<String, dynamic> toJson = {

      "fromDate": _fromDateTime.toString(), //.millisecondsSinceEpoch   //DateFormat('yyyy -MM -dd').format(_fromDateTime)
      "toDate": _toDateTime.toString(),
      "active": active,
      "drugText": drugText,
      "notificationId": notificationId,
      "startDate": DateFormat('yyyy/M/d').format(_fromDateTime),   //for裝置
      "endDate": DateFormat('yyyy/M/d').format(_toDateTime),    //for裝置
      "time": DateFormat('HH:mm:s').format(_fromDateTime),  //for裝置
      "time1":"${time1.hour}:${time1.minute}",
      "time2":"${time2.hour}:${time2.minute}",
    };
    drugB.reference().push().set(toJson);
  }

}
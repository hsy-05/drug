import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter1/authHome/model/time_entry.dart';
import 'package:flutter1/helpers/device_input.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter1/authHome/model/time_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/authHome/time_content/screens/search.dart';
import 'package:flutter1/authHome/time_content/screens/med_mode.dart';

class AddDrugA extends StatefulWidget {

  @override
  _AddDrugAState createState() => _AddDrugAState();
}

class _AddDrugAState extends State<AddDrugA> {

  String drugText;
  TextEditingController _drugnameController;
  DateTime _fromDateTimeA1 = new DateTime.now();
  DateTime _fromDateTimeA2 = new DateTime.now();
  DateTime _fromDateTimeA3 = new DateTime.now();
  DateTime _toDateTime = new DateTime.now();
  TimeOfDay time1 = new TimeOfDay.now();
  TimeOfDay time2 = new TimeOfDay.now();
  TimeOfDay time3 = new TimeOfDay.now();

  DatabaseReference drugA;

  @override
  void initState() {
    super.initState();
    print("GetDeviceID.getDeviceID：：");
    print(GetDeviceID.getDeviceID);
    _drugnameController = TextEditingController(text: "");
    drugA = FirebaseDatabase.instance.reference().child("device").child(GetDeviceID.getDeviceID).child("drugA");
  }


  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Color.fromRGBO(210, 180, 140, 1.0),
      actions: [
        new FlatButton(
          onPressed: () async {
            if(drugText.isEmpty||drugText==null){
              Fluttertoast.showToast(msg: '無法使用此裝置ID',
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.orange,
                  textColor: Colors.black,
                  webPosition: "center",
                  fontSize: 22.0);

            }else{
              saveContact();
              // drugA.reference().push().set(drugText);
              Navigator.of(context).pop();
            }

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
              minLeadingWidth: 5,
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  new Icon(Icons.drive_file_rename_outline, size: 24),
                  new Text("藥品暱稱 : ", style: TextStyle(fontSize: 20)),
                ],
              ),
              title: TextFormField(
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                  cursorColor: Colors.black,
                  autofocus: false,
                  controller: _drugnameController,
                  decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  )

              ),
            ),
            new ListTile(
              horizontalTitleGap: 10,
              minLeadingWidth: 0,
              onTap: (() => _showFromDatePicker(context)),
              leading: new Icon(Icons.today, size: 22),
              title: Text("開始日期", style: TextStyle(fontSize: 18)),
              trailing: Text(
                new DateFormat('yyyy年 MM月 dd日').format(_fromDateTimeA1),//設定畫面的年月日
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
              horizontalTitleGap: 10,
              minLeadingWidth: 0,
              leading: new Icon(Icons.format_list_bulleted_rounded),
              title: Text(
                "服藥模式",
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                _returnValueOfDrugTime(context);

              },
            ),
            // new ListTile(
            //   title: Text(
            //     time1.format(context),
            //     style: TextStyle(fontSize: 18),
            //   ),
            // ),
            Visibility(
              visible: RadioValue.selectedRadio0,
              child: new ListTile(
                horizontalTitleGap: 10,
                minLeadingWidth: 0,
                title: Text("第1個時間:"),
                trailing: Text(
                  time1.format(context),
                  style: TextStyle(fontSize: 18),
                ), //設定畫面的時間
              ),
            ),
            Visibility(
              visible: RadioValue.selectedRadio1,
              child: new ListTile(
                horizontalTitleGap: 10,
                minLeadingWidth: 0,
                title: Text("第2個時間:"),
                trailing: Text(
                  time2.format(context),
                  style: TextStyle(fontSize: 18),
                ), //設定畫面的時間
              ),
            ),
            Visibility(
              visible: RadioValue.selectedRadio2,
              child: new ListTile(
                horizontalTitleGap: 10,
                minLeadingWidth: 0,
                title: Text("第3個時間:"),
                trailing: Text(
                  time3.format(context),
                  style: TextStyle(fontSize: 18),
                ), //設定畫面的時間
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
      time1 = result[0];
      _fromDateTimeA1 = new DateTime(_fromDateTimeA1.year, _fromDateTimeA1.month,
          _fromDateTimeA1.day, time1.hour, time1.minute);
      _toDateTime = new DateTime(_toDateTime.year, _toDateTime.month,
          _toDateTime.day, 23, 59);
      time2 = result[1];
      _fromDateTimeA2 = new DateTime(_fromDateTimeA2.year, _fromDateTimeA2.month,
          _fromDateTimeA2.day, time2.hour, time2.minute);
      time3 = result[2];
      _fromDateTimeA3 = new DateTime(_fromDateTimeA3.year, _fromDateTimeA3.month,
          _fromDateTimeA3.day, time3.hour, time3.minute);
    });
  }

  Future _showFromDatePicker(BuildContext context) async {
    DateTime dateTimePicked = await showDatePicker(
        context: context,
        initialDate: _fromDateTimeA1,
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
        firstDate: _fromDateTimeA1.subtract(const Duration(days: 20000)),
        lastDate: new DateTime(2033, 12, 31));

    if (dateTimePicked != null) {
      _fromDateTimeA1 = new DateTime(dateTimePicked.year, dateTimePicked.month,
          dateTimePicked.day, time1.hour, time1.minute);
      _fromDateTimeA2 = new DateTime(_fromDateTimeA2.year, _fromDateTimeA2.month,
          _fromDateTimeA2.day, time2.hour, time2.minute);
      _fromDateTimeA3 = new DateTime(_fromDateTimeA3.year, _fromDateTimeA3.month,
          _fromDateTimeA3.day, time3.hour, time3.minute);
      setState(() {
        _fromDateTimeA1 = dateTimePicked;
        // fromDate = dateTimePicked;
        // return fromDate;
      });
    }
  }

  Future _showToDatePicker (BuildContext context) async {
    DateTime dateTimePicked = await showDatePicker(
        context: context,
        initialDate: _toDateTime.add(const Duration(days: 2)),
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
        firstDate: DateTime.now(),
        lastDate: new DateTime(2033, 12, 31));

    if (dateTimePicked != null) {
      _toDateTime = new DateTime(dateTimePicked.year, dateTimePicked.month,
          dateTimePicked.day, 23, 59);
      setState(() {
        _toDateTime = dateTimePicked;
        // toDate = dateTimePicked;
        // return toDate;
      });
    }
  }


  void saveContact(){

    int notificationId1 = Random().nextInt(1000);
    int notificationId2 = Random().nextInt(1000);
    int notificationId3 = Random().nextInt(1000);
    var different = _toDateTime.difference(_fromDateTimeA1).inDays;
    List<String> twoTimes = [];
    twoTimes.add("${time1.hour}:${time1.minute}");
    twoTimes.add("${time2.hour}:${time2.minute}");
    twoTimes.sort((a,b) => a.compareTo(b));

    List<String> threeTimes = [];
    threeTimes.add("${time1.hour}:${time1.minute}");
    threeTimes.add("${time2.hour}:${time2.minute}");
    threeTimes.add("${time3.hour}:${time3.minute}");
    threeTimes.sort((a,b) => a.compareTo(b));

    print("計算天數");
    print(different); // 19362
    if(RadioValue.radiovalue == 0){
      Map<String, dynamic> toJson = {

        "fromDate1": _fromDateTimeA1.toString(), //.millisecondsSinceEpoch   //DateFormat('yyyy -MM -dd').format(_fromDateTime1)
        "toDate": _toDateTime.toString(),
        "drugText": drugText,
        "nickName": _drugnameController.text,
        "notificationId1": notificationId1,
        "startDate": DateFormat('yyyy/M/d').format(_fromDateTimeA1),
        "endDate": DateFormat('yyyy/M/d').format(_toDateTime),
        "time1":"${time1.hour}:${time1.minute}",
        // "time1":"${time1.hour}:${time1.minute}",
      };
      drugA.reference().push().set(toJson);
    }
    if(RadioValue.radiovalue == 1){
      Map<String, dynamic> toJson = {

        "fromDate1": _fromDateTimeA1.toString(), //.millisecondsSinceEpoch   //DateFormat('yyyy -MM -dd').format(_fromDateTime1)
        "fromDate2": _fromDateTimeA2.toString(),
        "toDate": _toDateTime.toString(),
        "drugText": drugText,
        "nickName": _drugnameController.text,
        "notificationId1": notificationId1,
        "notificationId2": notificationId2,
        "startDate": DateFormat('yyyy/M/d').format(_fromDateTimeA1),
        "endDate": DateFormat('yyyy/M/d').format(_toDateTime),
        "time1":twoTimes[0],
        "time2":twoTimes[1],
      };
      drugA.reference().push().set(toJson);
    }
    if(RadioValue.radiovalue == 2){
      Map<String, dynamic> toJson = {

        "fromDate1": _fromDateTimeA1.toString(), //.millisecondsSinceEpoch   //DateFormat('yyyy -MM -dd').format(_fromDateTime1)
        "fromDate2": _fromDateTimeA2.toString(),
        "fromDate3": _fromDateTimeA3.toString(),"toDate": _toDateTime.toString(),
        "drugText": drugText,
        "nickName": _drugnameController.text,
        "notificationId1": notificationId1,
        "notificationId2": notificationId2,
        "notificationId3": notificationId3,
        "startDate": DateFormat('yyyy/M/d').format(_fromDateTimeA1),
        "endDate": DateFormat('yyyy/M/d').format(_toDateTime),
        "time1":threeTimes[0],
        "time2":threeTimes[1],
        "time3": threeTimes[2],
      };
      drugA.reference().push().set(toJson);
    }
  }

}
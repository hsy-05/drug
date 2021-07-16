import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddScreen extends StatelessWidget {
  AddScreen({Key key, DateTime dateTime, @required this.onChanged})
      : assert(onChanged != null),
        date = dateTime == null
            ? new DateTime.now()
            : new DateTime.utc(dateTime.year, dateTime.month, dateTime.day),
        time = dateTime == null
            ? new DateTime.now()
            : new TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        super(key: key);

  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<DateTime> onChanged;

  //設定date time 的畫面
  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new InkWell(
          onTap: (() => _showDatePicker(context)),

          child: new Padding(
            padding: new EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Icon(Icons.today, size:22),
                  new Text("開始日期", style: TextStyle(fontSize: 18)),
                  SizedBox(width: 20),
                  new Text(new DateFormat('yyyy - MM - dd').format(date), style: TextStyle(fontSize: 18),),
                  //設定畫面的年月日
                ]),
          ),
        ),
        new InkWell(
          onTap: (() => _showTimePicker(context)),
          child: new Padding(
            padding: new EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Icon(Icons.access_alarms_rounded, size:22),
                  new Text("新增服藥時間", style: TextStyle(fontSize: 18)),
                  SizedBox(width: 20),
                  new Text(time.format(context), style: TextStyle(fontSize: 18),), //設定畫面的時間
                ]),
          ),
        ),
      ],
    );
  }

  Future _showDatePicker(BuildContext context) async {
    DateTime dateTimePicked = await showDatePicker(
        context: context,
        initialDate: date,

        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Color.fromRGBO(210, 180, 140, 1.0), // header background color
                onPrimary: Colors.black, // header text color
                onSurface: Colors.black, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: Color.fromRGBO(204, 119, 34, 1.0), // button text color
                ),
              ),
            ),
            child: child,
          );
        },

        firstDate: date.subtract(const Duration(days: 20000)),
        lastDate: new DateTime(2033, 12, 31));

    if (dateTimePicked != null) {
      onChanged(new DateTime(dateTimePicked.year, dateTimePicked.month,
          dateTimePicked.day, time.hour, time.minute));
    }
  }

  Future _showTimePicker(BuildContext context) async {
    TimeOfDay timeOfDay =
        await showTimePicker(context: context, initialTime: time);

    if (timeOfDay != null) {
      onChanged(new DateTime(
          date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute));
    }
  }
}

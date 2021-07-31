import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddScreen extends StatelessWidget {
  AddScreen({Key key, DateTime dateTime, @required this.onChanged})
      : assert(onChanged != null),
        date = dateTime == null
            ? new DateTime.now().millisecondsSinceEpoch
            : new DateTime.utc(dateTime.year, dateTime.month, dateTime.day),
        time = dateTime == null
            ? new DateTime.now().millisecondsSinceEpoch
            : new TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        super(key: key);

  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<DateTime> onChanged;

  //設定date time 的畫面
  @override
  Widget build(BuildContext context) {
    return new Column(

      children: ListTile.divideTiles(context: context, tiles: [
        new ListTile(
          horizontalTitleGap: 10,
          minLeadingWidth: 0,
          onTap: (() => _showDatePicker(context)),
          leading: new Icon(Icons.today, size: 22),
          title: Text("開始日期", style: TextStyle(fontSize: 18)),
          trailing: Text(
                    new DateFormat('yyyy年 MM月 dd日').format(date),//設定畫面的年月日
                    style: TextStyle(fontSize: 18),
                  ),
          ),

        new ListTile(
          horizontalTitleGap: 10,
          minLeadingWidth: 0,
          onTap: (() => _showTimePicker(context)),
          leading: new Icon(Icons.access_alarms_rounded, size: 22),
          title: Text("新增服藥時間", style: TextStyle(fontSize: 18)),
          trailing: Text(
            time.format(context),
            style: TextStyle(fontSize: 18),
          ), //設定畫面的時間
        ),
      ]).toList(),
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

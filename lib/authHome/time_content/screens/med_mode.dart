import 'package:flutter/material.dart';

class MedicineMode extends StatefulWidget {

  @override
  MedicineModeState createState() => MedicineModeState();
}

class MedicineModeState extends State<MedicineMode> {
  int selectedRadio = 0;
  // TimeOfDay time;
  TimeOfDay _time = new TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(210, 180, 140, 1.0),
        actions: [
          new FlatButton(
            child: new Text('完成',
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: Colors.white, fontSize: 20.0)),
            onPressed: () {
              _sendDataBack(context);
            },
          ),
        ],
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Text(
              "服藥模式",
              style: TextStyle(fontSize: 22),
            ),
            RadioListTile(
              value: 0,
              onChanged: (value) {
                setState(() {
                  this.selectedRadio = value;
                });
              },
              groupValue: this.selectedRadio,
              title: Text("一天1次"),
              selected: this.selectedRadio == 0,
            ),
            RadioListTile(
              value: 1,
              onChanged: (value) {
                setState(() {
                  this.selectedRadio = value;
                });
              },
              groupValue: this.selectedRadio,
              title: Text("一天2次"),
              selected: this.selectedRadio == 1,
            ),
            RadioListTile(
              value: 2,
              onChanged: (value) {
                setState(() {
                  this.selectedRadio = value;
                });
              },
              groupValue: this.selectedRadio,
              title: Text("一天3次"),
              selected: this.selectedRadio == 2,
            ),


            new ListTile(
              horizontalTitleGap: 10,
              minLeadingWidth: 0,
              onTap: (() => _showTimePicker(context)),
              leading: new Icon(Icons.access_alarms_rounded, size: 22),
              title: Text("新增服藥時間", style: TextStyle(fontSize: 18)),
              trailing: Text(
                _time.format(context),
                style: TextStyle(fontSize: 18),
              ), //設定畫面的時間
            ),
          ],
        ),
      ),
    );
  }

  Future _showTimePicker(BuildContext context) async {
    TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: _time,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color.fromRGBO(227, 137, 2, 1.0),
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
    );
    if (timeOfDay != null) {
      setState(() {
        _time = timeOfDay;
        // time = timeOfDay;
        // return time;
      });
    }
  }

  void _sendDataBack(BuildContext context) {
    TimeOfDay timeBack = _time;
    Navigator.pop(context, timeBack);
  }
}
// }

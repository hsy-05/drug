import 'package:flutter1/authHome/model/time_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart'; //
import 'screens/add_time.dart';


class SettingsForm extends StatefulWidget {
  final Times timeToAdd;

  const SettingsForm({Key key, this.timeToAdd}) : super(key: key);

  @override
  _SettingsFormState createState() {
    if (timeToAdd != null) {
      return new _SettingsFormState(
          timeToAdd.dateTime); //weighEntryToEdit.note
    } else {
      return new _SettingsFormState(new DateTime.now());
    }
  }
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();

  DateTime _dateTime = new DateTime.now();

  _SettingsFormState(this._dateTime);

  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      actions: [
        new FlatButton(
          onPressed: () async {

            await Entry.addItem(
              dateTime: _dateTime.toString(),
            );
            Navigator.of(context).pop();
            // Navigator.of(context).pop(new Times(dateTime: _dateTime)); //_note
          },
          child: new Text('SAVE',
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _createAppBar(context),
      body: new Column(
        children: [
          new ListTile(
            leading: new Icon(Icons.today, color: Colors.grey[500]),
            title: new AddScreen(
              dateTime: _dateTime,
              onChanged: (dateTime) => setState(() => _dateTime = dateTime),
            ),
          ),
          SizedBox(height: 30.0),

          Container(
            width: double.maxFinite,
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pop(new Times(dateTime: _dateTime)); //_note
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Text(
                  'ADD ITEM',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

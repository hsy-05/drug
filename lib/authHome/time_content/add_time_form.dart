import 'package:flutter1/authHome/model/time_firebase.dart';
import 'package:flutter/material.dart';
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
  final _addItemFormKey = GlobalKey<FormState>();
  final TextEditingController _drugTextController = TextEditingController();

  DateTime _dateTime = new DateTime.now();

  _SettingsFormState(this._dateTime);

  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      actions: [
        new FlatButton(
          onPressed: () async {
            await Entry.addItem(
              dateTime: _dateTime.toString(),
              drugText: _drugTextController.text,
            );
            Navigator.of(context).pop();
            // Navigator.of(context).pop(new Times(dateTime: _dateTime)); //_note
          },
          child: new Text('SAVE',
              style: Theme
                  .of(context)
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
          new Form(
            key: _addItemFormKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '藥品名稱',
                    style: TextStyle(
                      color: Color.fromRGBO(255, 123, 23, 1.0),
                      fontSize: 22.0,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _drugTextController,
                    // focusNode: widget.titleFocusNode,
                    decoration: InputDecoration(
                      // labelText: "藥品名稱",
                      hintText: '藥品名稱',
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,

                  ),
                  SizedBox(height: 24.0),
                ]
            ),
          ),

          SizedBox(height: 30.0),

          new ListTile(
            leading: new Icon(Icons.today, color: Colors.grey[500]),
            title: new AddScreen(
              dateTime: _dateTime,
              onChanged: (dateTime) => setState(() => _dateTime = dateTime),
            ),
          ),

        ],
      ),
    );
  }
}

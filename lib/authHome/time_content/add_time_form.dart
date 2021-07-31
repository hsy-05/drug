import 'package:flutter1/authHome/model/time_firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/authHome/time_content/screens/search.dart';
import 'screens/add_time.dart';

class AddForm extends StatefulWidget {
  final Times timeToAdd;
  final String text;

  const AddForm({Key key, this.timeToAdd, this.text}) : super(key: key);

  @override
  _AddFormState createState() {
    if (timeToAdd != null) {
      return new _AddFormState(timeToAdd.dateTime); //weighEntryToEdit.note
    } else {
      return new _AddFormState(new DateTime.now());
    }
  }
}

class _AddFormState extends State<AddForm> {
  final _addItemFormKey = GlobalKey<FormState>();

  DateTime _dateTime = new DateTime.now();

  _AddFormState(this._dateTime);

  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Color.fromRGBO(210, 180, 140, 1.0),
      actions: [
        new FlatButton(
          onPressed: () async {
            await Entry.addItem(
              dateTime: _dateTime,
              drugText: text,
            );
            Navigator.of(context).pop();
            // Navigator.of(context).pop(new Times(dateTime: _dateTime)); //_note
          },
          child: new Text('新增',
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white, fontSize: 20.0)),
        ),
      ],
    );
  }

  String text;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _createAppBar(context),
      body: new Padding(
        padding: const EdgeInsets.all(15),
        child: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            new ListTile(
              horizontalTitleGap: 0,
              contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
              title: new AddScreen(
                dateTime: _dateTime,
                onChanged: (dateTime) => setState(() => _dateTime = dateTime),
              ),
            ),
            new Form(
              key: _addItemFormKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.0), //

                    ListTile(
                      title: Text(
                        "新增藥品名稱",
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        _returnValueOfDrugText(context);
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            text ?? "",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35.0),
                  ]),
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
      text = result;
    });
  }
}

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
      return new _AddFormState(timeToAdd.fromDateTime, timeToAdd.toDateTime); //weighEntryToEdit.note
    } else {
      return new _AddFormState(new DateTime.now(), new DateTime.now());
    }
  }
}

class _AddFormState extends State<AddForm> {
  // final _addItemFormKey = GlobalKey<FormState>();

  DateTime _fromDateTime = new DateTime.now();
  DateTime _toDateTime = new DateTime.now();

  _AddFormState(this._fromDateTime, this._toDateTime);

  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      backgroundColor: Color.fromRGBO(210, 180, 140, 1.0),
      actions: [
        new FlatButton(
          onPressed: () async {
            await Entry.addItem(
              fromDateTime: _fromDateTime,
              toDateTime: _toDateTime,
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
                fromDateTime: _fromDateTime,
                toDateTime: _toDateTime,
                onFromChanged: (fromDateTime) => setState(() => _fromDateTime = fromDateTime),
                onToChanged: (toDateTime) => setState(() => _toDateTime = toDateTime),
              ),
            ),
          // new Form(
          //     key: _addItemFormKey,
            ListTile(
              horizontalTitleGap: 10,
              minLeadingWidth: 0,
              leading: new Icon(Icons.search),
              title: Text(
                text ?? "新增藥品名稱",
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
            ListTile(
              title: Text(
                "服藥模式",
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
      text = result;
    });
  }
}

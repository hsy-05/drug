//當按下Home按鈕時，出現的介面
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/authHome/time_content/list_item.dart';
import 'package:flutter1/authHome/time_content/add_time_form.dart';

class SetTime extends StatefulWidget {
  SetTime({Key key}) : super(key: key);
  _SetState createState() => _SetState();
}

class _SetState extends State<SetTime> {
  Widget build(BuildContext context) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Color.fromRGBO(126, 153, 120, 1.0),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SettingsForm(),
              ),
            );
          },
        ),
        body: SafeArea(     //每個List的顯示
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: TimeListItem(),
          ),
        ),
      );
  }
}
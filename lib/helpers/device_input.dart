import 'package:flutter/material.dart';


Future<String> inputDeviceID(BuildContext context) async {
  String inputData = '';
  return showDialog<String>(
    context: context,
    barrierDismissible: false, //控制點擊對話框以外的區域是否隱藏對話框
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('請輸入裝置ID'),
        content: new Row(
          children: <Widget>[
            new Expanded(
                child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      hintText: '請輸入裝置ID...'),
                  onChanged: (value) {
                    inputData = value;
                  },
                ))
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('送出'),
            onPressed: () {
              Navigator.of(context).pop(inputData);
            },
          ),
        ],
      );
    },
  );
}


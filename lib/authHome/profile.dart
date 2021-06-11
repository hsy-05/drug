//當按下Home按鈕時，出現的介面
import 'package:flutter/material.dart';
import '../helpers/Constants.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _pwdController = new TextEditingController();
  TextEditingController _repwdController = new TextEditingController();
  TextEditingController _pnController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        iconTheme: IconThemeData(
          color: Colors.grey, //change your color here
        ),
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Row(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.only(top: 20.0,left: 50.0),
                  child: Text(
                    "下次吃藥時間4",
                    style: TextStyle(fontSize: 28,letterSpacing: 8.0),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: Stack(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
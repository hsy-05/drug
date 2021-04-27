//當按下Home按鈕時，出現的介面
import 'package:flutter/material.dart';
import 'helpers/Constants.dart';

class PagesHome extends StatefulWidget {
  PagesHome({Key key}) : super(key: key);

  _PagesHomeState createState() => _PagesHomeState();
  }

class _PagesHomeState extends State<PagesHome> {
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
                Hero(
                  tag: "main-logo",
                  child: SizedBox(
                    height: 80,
                    child: appLogo,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0,left: 50.0),
                  child: Text(
                    "下次吃藥時間",
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
                      Padding(
                        
                      ),
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
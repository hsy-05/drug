//當按下Home按鈕時，出現的介面
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/utils/auth_helper.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.auth}) : super(key: key);
  final AuthHelper auth;

  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _oldPWController = new TextEditingController();
  TextEditingController _newPWController = new TextEditingController();
  TextEditingController _confirmPWController = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool checkCurrentPasswordValid = true;
  User _user;

  String _confirmsword = "";

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() async {
    _user = await FirebaseAuth.instance.currentUser;
    setState(() {});
  }

  _ProfileState() {
    _confirmPWController.addListener(_passwordListen);
  }

  void _passwordListen() {
    if (_confirmPWController.text.isEmpty) {
      _confirmsword = "";
    } else {
      _confirmsword = _confirmPWController.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    // final oldPW = TextField(
    //   autofocus: true,
    //   controller: _oldPWController,
    //   decoration: InputDecoration(
    //       labelText: "請輸入舊密碼",
    //       labelStyle: TextStyle(color: Colors.black),
    //       focusedBorder: UnderlineInputBorder(
    //         borderSide: BorderSide(color: Colors.black),
    //       ),
    //       prefixIcon: Icon(Icons.lock_outline,color:Colors.black,)
    //   ),
    // );

    final newPW = TextFormField(
      autofocus: true,
      controller: _newPWController,
      decoration: InputDecoration(
          labelText: "請輸入新密碼",
          labelStyle: TextStyle(color: Colors.black),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.black,
          )),
      validator: (String value) {
        if (value.isEmpty) {
          return '請輸入新密碼！';
        }

        return null;
      },
    );

    final confirmPW = TextFormField(
      autofocus: true,
      controller: _confirmPWController,
      decoration: InputDecoration(
          labelText: "確認新密碼",
          labelStyle: TextStyle(color: Colors.black),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.black,
          )),
      validator: (String value) {
        if (value.isEmpty) {
          return '請再次輸入新密碼！';
        }
        print(_newPWController.text);

        print(_confirmPWController.text);

        if (_newPWController.text != _confirmPWController.text) {
          return "兩次密碼不相同";
        }

        return null;
      },
    );

    return new Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3.0),
            Text(
              '會員帳號',
              style: TextStyle(
                backgroundColor: Color.fromRGBO(210, 180, 140, 1.0),
                fontSize: 20.0,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                SizedBox(
                  child: Text(
                    '信箱：',
                    style: TextStyle(
                      fontSize: 18.0,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                SizedBox(
                  child: Text(
                    _user?.email ?? '',
                    style: TextStyle(
                      fontSize: 18.0,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            new Form(
              key: _formKey,
              autovalidate: false, //是否自動校驗輸入內容
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        SizedBox(
                          child: Text(
                            '姓名：',
                            style: TextStyle(
                              fontSize: 18.0,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Text(
                            _user?.displayName ?? '',
                            style: TextStyle(
                              fontSize: 18.0,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.0),
                    //
                    Text(
                      '修改密碼',
                      style: TextStyle(
                        backgroundColor: Color.fromRGBO(210, 180, 140, 1.0),
                        fontSize: 20.0,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    newPW,
                    SizedBox(height: 10.0),
                    confirmPW,
                    SizedBox(height: 18.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 250),
                      child: RaisedButton(
                        child: Text(
                          "修改",
                          style: TextStyle(fontSize: 20),
                        ),
                        color: Color.fromRGBO(210, 180, 140, 1.0),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            try {
                              print("NewPassword=========>" + _confirmsword);
                              AuthHelper.changePassword(_confirmsword);
                              AuthHelper.changePassword(_confirmsword);
                              print("更改成功");
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    ));
  }
}

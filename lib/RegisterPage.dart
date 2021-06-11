import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'authHome/model/time_firebase.dart';
import 'helpers/Constants.dart';
import 'package:flutter1/utils/auth_helper.dart';

//註冊畫面
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _confirmPasswordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final name = TextFormField(
      autofocus: false,
      controller: _nameController,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.person,
            color: Colors.grey,
          ), // icon is 48px widget.
        ),
        labelText: "名稱",
        hintText: "請輸入名稱",
        contentPadding: EdgeInsets.fromLTRB(
            20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(20.0)),
      ),
      validator: (value) => value.isEmpty ? '記得輸入名稱！' : null,
      onChanged: (value) {
        setState(() => Name = value);
      },
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _emailController,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.email,
            color: Colors.grey,
          ), // icon is 48px widget.
        ),
        labelText: "信箱帳號",
        hintText: "請輸入帳號",
        contentPadding: EdgeInsets.fromLTRB(
            20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(20.0)),
      ),
      validator: (value) => value.isEmpty ? '記得填寫信箱！' : null,
      onChanged: (value) {
        setState(() => Email = value);
      },
    );

    final password = TextFormField(
      autofocus: false,
      controller: _passwordController,
      obscureText: true,
      //是否隱藏正在編輯的文字
      decoration: InputDecoration(
        //編輯TextField的外觀顯示
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
            color: Colors.grey,
          ), // icon is 48px widget.
        ), // icon is 48px widget.
        labelText: "密碼",
        hintText: "請輸入密碼",
        contentPadding: EdgeInsets.fromLTRB(
            20.0, 15.0, 20.0, 15.0), //上右下左
        border: OutlineInputBorder(
            borderRadius:
            BorderRadius.circular(20.0)),
      ),
      validator: (value) => value.isEmpty ? '記得填寫密碼！' : null,
      onChanged: (value) {
        setState(() => Password = value);
      },
    );

    final comfirmPassword = TextFormField(
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        contentPadding:
        EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0)),
        labelText: "再次輸入密碼",
        hintText: "請再次輸入密碼",
      ),
      obscureText: true,
      validator: (value) => value.isEmpty ? '請再填寫一次密碼！' : null,
      onChanged: (value) {
        setState(() => Password = value);
      },
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme
            .of(context)
            .canvasColor,
        iconTheme: IconThemeData(
          color: Colors.grey, //更改appBar顏色
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
                    height: 100,
                    child: appLogo,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0, left: 25.0),
                  child: Text(
                    "用戶註冊",
                    style: TextStyle(fontSize: 28, letterSpacing: 8.0),
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
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        child: Form(
                          key: _formKey,
                          autovalidate: false, //是否自動校驗輸入內容
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            name,
                            SizedBox(height: 32,),
                            email,
                            SizedBox(height: 32,),
                            password,
                            SizedBox(height: 32,),
                            comfirmPassword,
                          ],
                        ),
                      ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 60, left: 60),
                        child: SizedBox(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 50,
                          child: RaisedButton(
                            child: Text("提交", style: buttonTextStyle),
                            elevation: 3,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)),

                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                try {
                                  final user = await AuthHelper.signInWithEmail(
                                      email: _emailController.text,
                                      password: _passwordController.text);
                                  if (user != null) {
                                    print("註冊成功");
                                  }
                                } catch (e) {
                                  print(e);
                                }
                              }

                              try {
                                final user = await AuthHelper.signupWithEmail(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text);
                                Entry.userid = _emailController.text;
                                if (user != null) {
                                  showDialog<Null>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return new AlertDialog(
                                        title: new Text(
                                          '註冊成功',
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Text(
                                          '請登入帳號並修改個人訊息',
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('確定'),
                                            onPressed: () async {      //
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                    builder: (context) =>HomePage(), //
                                                  ));
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ).then((val) {
                                    print(val);
                                  });
                                };
                              } catch (e) {
                                print(e);
                              }
                            },
                          ),
                        ),
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

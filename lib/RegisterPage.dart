import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'package:flutter1/utils/auth_helper.dart';

//註冊畫面
class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _confirmPasswordController = TextEditingController(text: "");
  }

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
                    "用戶註冊",
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
                        padding: const EdgeInsets.only(left: 60, right: 60),
                        key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  labelText: "信箱帳號",
                                  hintText: "請輸入信箱帳號",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(32.0)),
                                ),
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(32.0)),
                                    labelText: "密碼",
                                    hintText: "請輸入至少6位密碼",
                                  ),
                                  obscureText: true,
                              ),
                              SizedBox(
                                height: 32,
                              ),
                              TextFormField(
                                  controller: _confirmPasswordController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(32.0)),
                                    labelText: "再次輸入密碼",
                                    hintText: "請再次輸入密碼",
                                  ),
                                  obscureText: true,
                                  ),
                            ],
                          ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 60, left: 60),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: RaisedButton(
                            child: Text("提交", style: buttonTextStyle),
                            elevation: 3,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)),

                            onPressed: () async {
                              try {
                                final user = await AuthHelper.signupWithEmail(
                                    email: _emailController.text,
                                    password: _passwordController.text);
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
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, '/register');
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ).then((val) {
                                  print(val);
                                });
                              }catch (e) {
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
            )],
        ),
      ),
    );
  }
}
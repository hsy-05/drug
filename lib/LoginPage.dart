import 'package:flutter/material.dart';
import 'authHome/model/time_firebase.dart';
import 'helpers/Constants.dart';
import 'package:flutter1/utils/auth_helper.dart';
import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController; //帳號輸入框
  TextEditingController _passwordController; //密碼輸入框
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0), //上下邊距
      child: SizedBox(
        width: MediaQuery //MediaQuery.of(context) 來獲取資料
                .of(context)
            .size
            .width,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BottomRadius), //按鈕邊角弧度
          ),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              try {
                final user = await AuthHelper.signInWithEmail(
                    email: _emailController.text,
                    password: _passwordController.text);
                if (user != null) {
                  print("登入成功");
                }
                Entry.userid = _emailController.text;
              } catch (e) {
                print(e);
              }
            }
          },
          padding: EdgeInsets.all(12),
          elevation: 5,
          //按鈕陰影
          color: Colors.white,
          child: Text(loginButtonText),
        ),
      ),
    );

    final RegisterButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BottomRadius),
          ),
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RegisterPage(),
                ));
          },
          padding: EdgeInsets.all(12),
          elevation: 5,
          color: Colors.white,
          child: Text(RegisterButtonText),
        ),
      ),
    );

    final LoginGoogleButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BottomRadius),
          ),
          onPressed: () async {
            try {
              await AuthHelper.signInWithGoogle();
            } catch (e) {
              print(e);
            }
          },
          padding: EdgeInsets.all(12),
          elevation: 5,
          color: Colors.white,
          child: Text(LoginWithGoogle),
        ),
      ),
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
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      validator: (value) => value.isEmpty ? '信箱不可為空' : null,
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
        ),
        // icon is 48px widget.
        labelText: "密碼",
        hintText: "請輸入密碼",
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        //上右下左
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      validator: (value) => value.isEmpty ? '密碼不可為空' : null,
      onChanged: (value) {
        setState(() => Password = value);
      },
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor, //
        // iconTheme: IconThemeData(color: Colors.grey), //change your color here
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: "main-logo", //
                  child: SizedBox(
                    height: 100,
                    child: appLogo,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0, left: 25.0),
                  child: Text(
                    "智慧藥盒",
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
                      mainAxisAlignment: MainAxisAlignment.center, //
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 60, right: 60),
                          child: Form(
                            key: _formKey,
                            autovalidate: false, //是否自動校驗輸入內容
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                email,
                                const SizedBox(height: 26,),
                                password,
                                const SizedBox(height: 50,), //文字框和按鈕間的距離
                                loginButton,
                                RegisterButton,
                                LoginGoogleButton
                              ],
                            ),
                          ),
                        ),
                      ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

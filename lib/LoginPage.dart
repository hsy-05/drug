import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'authHome/model/time_firebase.dart';
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
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 35.0), //上下邊距
      child: SizedBox(
        width: MediaQuery //MediaQuery.of(context) 來獲取資料
                .of(context)
            .size
            .width,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(BottomRadius)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: buttonbg,
            child: Container(
              constraints: BoxConstraints(maxWidth: 280.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                loginButtonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                // Entry.userid = _emailController.text;
              } catch (e) {
                print(e);
              }
            }
          },
        ),
      ),
    );

    final RegisterButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0), //上下邊距
      child: SizedBox(
        width: MediaQuery //MediaQuery.of(context) 來獲取資料
                .of(context)
            .size
            .width,
        child: CupertinoButton(
          padding: EdgeInsets.all(0.0),
          child: Ink(
            child: Container(
              constraints: BoxConstraints(maxWidth: 180.0, minHeight: 50.0),
              alignment: Alignment.center,
              child: Text(
                RegisterButtonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RegisterPage(),
                ));
          },
        ),
      ),
    );

    final LoginGoogleButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 36.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: CupertinoButton(
          onPressed: () async {
            try {
              await AuthHelper.signInWithGoogle();
            } catch (e) {
              print(e);
            }
          },
          padding: EdgeInsets.all(0.0),
          child: Text(LoginWithGoogle,style: TextStyle(color: Colors.black54, ),
          ),
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
      // onChanged: (value) {
      //   setState(() => Email = value);
      // },
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
      // onChanged: (value) {
      //   setState(() => Password = value);
      // },
    );
    return new SafeArea(
      top: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: new Container(
          child: new Column(
            children: [
              new Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3.0,
                      // padding: const EdgeInsets.only(top: 80), ////
                      child: Hero(
                        tag: "main-logo", //
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: appLogo,
                        ),
                      ),

              ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center, //
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 70, left: 60, right: 60),
                          child: Form(
                            key: _formKey,
                            autovalidate: false, //是否自動校驗輸入內容
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                email,
                                const SizedBox(
                                  height: 26,
                                ),
                                password,
                                const SizedBox(
                                  height: 35,
                                ),
                                loginButton,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(child:RegisterButton ,),
                        Expanded(child: LoginGoogleButton),
                      ],
                    ),

            ],
          ),
        ),
      ),
    );
  }
}

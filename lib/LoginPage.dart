import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'package:flutter1/utils/auth_helper.dart';
import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final logo = CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: bigRadius,
      child: appLogo,
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          onPressed: () async {
            if (_emailController.text.isEmpty ||
                _passwordController.text.isEmpty) {
              print("帳號和密碼不可為空");
              return;
            }
            try {
              final user = await AuthHelper.signInWithEmail(
                  email: _emailController.text,
                  password: _passwordController.text);
              if (user != null) {
                print("登入成功");
              }
            } catch (e) {
              print(e);
            }
          },
          padding: EdgeInsets.all(12),
          elevation: 3,
          color: Colors.white,
          child: Text(loginButtonText),
        ),
      ),
    );

    final RegisterButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RegisterPage(),
                ));
          },

          padding: EdgeInsets.all(12),
          elevation: 3,
          color: Colors.white,
          child: Text(RegisterButtonText),
        ),
      ),
    );

    final LoginGoogleButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          onPressed: () async {
            try {
              await AuthHelper.signInWithGoogle();
            } catch (e) {
              print(e);
            }
          },
          padding: EdgeInsets.all(12),
          elevation: 3,
          color: Colors.white,
          child: Text("Login with Google"),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme
            .of(context)
            .canvasColor,
        iconTheme: IconThemeData(color: Colors.grey), //change your color here
      ),
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            const SizedBox(height: 16,),
            Row(
              children: <Widget>[
                Hero(
                  tag: "main-logo",
                  child: SizedBox(
                    height: 100,
                    child: Image.asset('assets/images/drug_icon.png'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 50.0),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 60, right: 60),
                          child: Form(
                            autovalidate: false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    labelText: "帳號",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(20.0)),
                                  ),
                                ),
                                const SizedBox(height: 26,),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(20.0)),
                                    labelText: "密碼",
                                    hintText: "請輸入密碼",
                                  ),
                                ),
                                const SizedBox(height: 26,),
                                const SizedBox(height: buttonHeight),
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
            )],
        ),
      ),
    );
  }
}
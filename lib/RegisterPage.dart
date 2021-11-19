import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter1/authHome/model/time_entry.dart';
import 'HomePage.dart';
// import 'authHome/model/time_firebase.dart';
import 'helpers/Constants.dart';
import 'helpers/auth_helper.dart';
import 'helpers/device_input.dart';

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
  String inputData;

  DatabaseReference deviceID;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _passwordController = TextEditingController(text: "");
    _confirmPasswordController = TextEditingController(text: "");
    deviceID = FirebaseDatabase.instance.reference().child("users");
  }

  @override
  Widget build(BuildContext context) {
    final name = TextFormField(
      cursorColor: Colors.grey,
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
        labelStyle: TextStyle(color: Colors.black54),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.grey)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.grey)),
        hintText: "請輸入名稱",
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      validator: (value) => value.isEmpty ? '記得輸入名稱！' : null,
      // onChanged: (value) {
      //   setState(() => Name = value);
      // },
    );

    final email = TextFormField(
      cursorColor: Colors.grey,
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
        labelStyle: TextStyle(color: Colors.black54),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.grey)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.grey)),
        hintText: "請輸入帳號",
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      validator: (value) => value.isEmpty ? '記得填寫信箱！' : null,
      // onChanged: (value) {
      //   setState(() => Email = value);
      // },
    );

    final password = TextFormField(
      cursorColor: Colors.grey,
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
        labelStyle: TextStyle(color: Colors.black54),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.grey)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.grey)),
        hintText: "請輸入密碼",
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        //上右下左
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),

      validator: (String value) {
        if (value.isEmpty) {
          return '記得填寫密碼！';
        }

        if (value.length < 6) {
          return "密碼需大於6位數";
        }

        return null;
      },
    );

    final comfirmPassword = TextFormField(
      cursorColor: Colors.grey,
      controller: _confirmPasswordController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Icon(
            Icons.lock,
            color: Colors.grey,
          ), // icon is 48px widget.
        ),
        labelText: "再次輸入密碼",
        labelStyle: TextStyle(color: Colors.black54),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.grey)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.grey)),
        hintText: "請再次輸入密碼",
      ),
      obscureText: true,
      // validator: (value) => value.isEmpty ? '請再填寫一次密碼！' : null,

      validator: (String value) {
        if (value.isEmpty) {
          return '請填寫再次密碼！';
        }

        if (_passwordController.text != _confirmPasswordController.text) {
          return "密碼不符合";
        }

        return null;
      },
    );

    return new SafeArea(
      top: false,
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: new Column(
            children: [
              new Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3.0,
                // decoration: bg,
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 60, right: 60),
                    child: Form(
                      key: _formKey,
                      autovalidate: false, //是否自動校驗輸入內容
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 5),
                          name,
                          SizedBox(height: 32),
                          email,
                          SizedBox(height: 32),
                          password,
                          SizedBox(height: 32),
                          comfirmPassword,
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.only(right: 60, left: 60),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(BottomRadius)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: buttonbg,
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 280.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "提交",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          // if (_confirmPasswordController.text.isEmpty ||
                          //     _passwordController.text !=
                          //         _confirmPasswordController.text) {
                          //   print("confirm password does not match");
                          //   return;
                          // }
                          if (_formKey.currentState.validate()) {
                            try {
                              final user = await AuthHelper.signupWithEmail(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text);
                              if (user != null) {
                                print("註冊成功");
                                inputData  = await inputDeviceID(context);
                                print("裝置ID：$inputData ");
                                await saveDeviceID();
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              print(e);
                            }

////715
//                             try {
//                               final user = await AuthHelper.signInWithEmail(
//                                   name: _nameController.text,
//                                   email: _emailController.text,
//                                   password: _passwordController.text);
//                               // Entry.userid = _emailController.text;
//                               if (user != null) {
//                                 showDialog<Null>(
//                                   context: context,
//                                   barrierDismissible: false,
//                                   builder: (BuildContext context) {
//                                     return new AlertDialog(
//                                       title: new Text(
//                                         '註冊成功',
//                                         textAlign: TextAlign.center,
//                                       ),
//                                       content: Text(
//                                         '請登入帳號並修改個人訊息',
//                                         textAlign: TextAlign.center,
//                                       ),
//                                       actions: <Widget>[
//                                         FlatButton(
//                                           child: Text('確定'),
//                                           onPressed: () async {
//                                             //
//                                             // Navigator.push(
//                                             //     context,
//                                             //     MaterialPageRoute(
//                                             //       builder: (context) =>
//                                             //           HomePage(), //
//                                             //     ));
//                                             // Navigator.pushAndRemoveUntil(
//                                             //     context,
//                                             //     MaterialPageRoute(
//                                             //         builder: (context) =>
//                                             //             HomePage()),
//                                             //         (_) => false);
//                                           },
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                 ).then((val) {
//                                   print(val);
//                                 });
//                               }
//                             } catch (e) {
//                               print(e);
//                             }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
   saveDeviceID() async{
    deviceID.reference().child(StaticInfo.userid).update({
      "deviceID": inputData,
    });
  }

}

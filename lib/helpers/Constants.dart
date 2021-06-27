import 'package:flutter/material.dart';

// Pages
const loginPageTag = 'Login Page';
const homePageTag = 'Home Page';
const RegisterPageTag = 'Register Page';

final buttonTextStyle = TextStyle(letterSpacing: 28.0);

// Colors
// Color appDarkGreyColor = Color.fromRGBO(234, 127, 26, 1.0);
// Color appGreyColor = Color.fromRGBO(210, 112, 20, .9); //按鈕

// Strings
const appTitle = "Contactly";
const pinCodeText = "帳號";
const pinCodeHintText = "請輸入手機號";
const loginButtonText = "登 入";
const RegisterButtonText = "註 冊";
const LoginWithGoogle = "使 用 Google 帳 戶 登 入"; //Login with Google

String Name = '';
String Email = '';
String Password = '';

// Images
Image appLogo = Image.asset('assets/images/drug_icon5.png');

// Sizes
const BottomRadius = 26.0;

const bg = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(254, 232, 171, 1.0),
      Color.fromRGBO(255, 123, 23, 1.0)
    ],
  ),
// borderRadius: BorderRadius.only(
//     bottomLeft: Radius.circular(30),
//     bottomRight: Radius.circular(30)
// )
);

const _radius = 30.0;
const buttonbg = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromRGBO(253, 200, 86 , 1.0),
        Color.fromRGBO(255, 123, 23, 1.0)
      ],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.all(Radius.circular(_radius))

);
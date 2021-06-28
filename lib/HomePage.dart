//登入後Home顯示的介面
import 'package:flutter/material.dart';
import 'helpers/placeholder_widget.dart';
import 'helpers/Constants.dart';
import 'package:flutter1/utils/auth_helper.dart';
import 'authHome/home.dart';      //換頁網址
import 'authHome/set_time.dart';  //換頁網址
import 'authHome/profile.dart';  //換頁網址
import 'authHome/record.dart';  //換頁網址

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  var _pageController = new PageController(initialPage: 0);
  String _title;

  @override
  initState(){
    _title = '智慧藥盒';
  }


  var pages = <Widget>[
    Home(),      //main要新增
    SetTime(),  //main要新增
    Record(), //main要新增
    Profile(),  //main要新增
   ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(126, 153, 120, 1.0),
        iconTheme: IconThemeData(color: Colors.grey), //change your color here
        leading: IconButton(
          icon: Icon(Icons.logout, color: Colors.black),
          onPressed: () {
            AuthHelper.logOut();
          },
        ),

        title: Text(_title, style: TextStyle(fontSize: 25, color: Colors.black)),
        centerTitle: true,
      ),

      // body: pages[_currentIndex], // new
      body: new PageView.builder(
        onPageChanged: _pageChange,
        controller: _pageController,
        itemCount: pages.length,
        itemBuilder: (BuildContext context, int index) {
          return pages.elementAt(_currentIndex);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
        fixedColor: Color.fromRGBO(126, 153, 120, 1.0),
          onTap: _onItemTapped, //click event
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('主頁'),

          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.access_alarms_rounded),
            title: Text('吃藥時間'),
          ),

          new BottomNavigationBarItem(
            icon: Icon(Icons.source_outlined),
            title: Text('吃藥紀錄'),
          ),

          new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('會員資料'),
          )
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    //bottomNavigationBar and PageView association
    _pageController.animateToPage(index,duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _pageChange(int index) {
    setState(() {
      _currentIndex = index;
      switch(index) {
        case 0: { _title = '智慧藥盒'; }
        break;
        case 1: { _title = '吃藥時間'; }
        break;
        case 2: { _title = '吃藥紀錄'; }
        break;
        case 3: { _title = '會員資料'; }
        break;
      }
    });
  }
}
import 'package:flutter/material.dart';

var _var1; // 이 변수는 다른파일에서는 불가능. 중복방지

var theme = ThemeData(
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    unselectedItemColor: Colors.black.withOpacity(0.2),
    selectedItemColor: Colors.black,
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: Colors.grey, //
      foregroundColor: Colors.white,
    )
  ), //  버튼 테마
  appBarTheme: AppBarTheme(
    color: Colors.white,
    elevation: 1,
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
    actionsIconTheme: IconThemeData(color: Colors.black), // APPBAR 위젯 테마 설정
  ),
  textTheme: TextTheme(
    bodyText2: TextStyle(color: Colors.black), // 텍스트 테마 설정
    bodyText1: TextStyle(color: Colors.red), // 텍스트 테마 설정

  ),
);

import 'package:flutter/material.dart';
import './Global.dart' as global;

final ThemeData LightThemeData = new ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.yellow[800],
    accentColor: Colors.yellow[800],
    textTheme: LightTextThemeData
);

final ThemeData DarkThemeData = new ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[850],
    accentColor: Colors.yellow[800],
    textTheme: DarkTextThemeData
);

final TextTheme LightTextThemeData = new TextTheme(
    title: new TextStyle(fontFamily: 'Niagara',
        fontSize: 40,
        color: Colors.grey[800].withOpacity(0.8)),
    body1: new TextStyle(fontFamily: 'Agatho',
        fontSize: 30,
        color: Colors.black.withOpacity(0.8)),
    body2: new TextStyle(fontFamily: 'Agatho',
        fontSize: 20,
        color: Colors.grey[800].withOpacity(0.8),
        fontWeight: FontWeight.bold),
    display1: new TextStyle(fontFamily: 'Agatho',
        fontSize: 40,
        color: Colors.black.withOpacity(0.8)),
    display2: new TextStyle(fontFamily: 'Agatho',
        fontSize: 30,
        color: Colors.grey[800].withOpacity(0.8),
        fontWeight: FontWeight.bold),
    display3: new TextStyle(fontFamily: 'Agatho',
            fontSize: 20,
            color: Colors.black.withOpacity(0.8),),
    display4: new TextStyle(fontFamily: 'Agatho',
            fontSize: 25,
            color: Colors.black.withOpacity(0.8),)
);

final TextTheme DarkTextThemeData = new TextTheme(
      title: new TextStyle(fontFamily: 'Niagara',
          fontSize: 40,
          color: Colors.yellow[800].withOpacity(0.8)),
      body1: new TextStyle(fontFamily: 'Agatho',
          fontSize: 30,
          color: Colors.white.withOpacity(0.8)),
      body2: new TextStyle(fontFamily: 'Agatho',
          fontSize: 20,
          color: Colors.grey[800].withOpacity(0.8),
          fontWeight: FontWeight.bold),
      display1: new TextStyle(fontFamily: 'Agatho',
          fontSize: 40,
          color: Colors.white.withOpacity(0.8)),
      display2: new TextStyle(fontFamily: 'Agatho',
          fontSize: 30,
          color: Colors.grey[800].withOpacity(0.8),
          fontWeight: FontWeight.bold),
      display3: new TextStyle(fontFamily: 'Agatho',
        fontSize: 20,
        color: Colors.white.withOpacity(0.8),),
      display4: new TextStyle(fontFamily: 'Agatho',
        fontSize: 25,
        color: Colors.white.withOpacity(0.8),)
);
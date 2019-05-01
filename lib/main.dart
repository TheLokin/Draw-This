import 'dart:io';
import 'package:draw_this/page/homePage.dart';
import 'package:draw_this/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

String databasePath;
String storagePath;

void main() async {
  Directory dir = await getApplicationDocumentsDirectory();
  String path = dir.path;
  databasePath = '$path/database.txt';
  storagePath = '$path/Cartoons';
  await Directory(storagePath).create(recursive: true);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(DrawThis());
}

class DrawThis extends StatefulWidget {
  @override
  _DrawThisState createState() => _DrawThisState();
}

class _DrawThisState extends State<DrawThis> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Draw This',
      home: HomePage(),
      theme: _buildLightTheme(),
    );
  }

  ThemeData _buildLightTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      primaryColor: cDrawThisPrimary,
      primaryTextTheme: _buildTextTheme(base.primaryTextTheme, cDrawThisBrown),
      primaryIconTheme: base.iconTheme.copyWith(color: cDrawThisBrown),
      buttonColor: cDrawThisPrimary,
      accentColor: cDrawThisBrown,
      scaffoldBackgroundColor: cDrawThisWhite,
      cardColor: Colors.white,
      textSelectionColor: cDrawThisPrimary,
      errorColor: cDrawThisError,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.accent,
      ),
      textSelectionHandleColor: cDrawThisPrimary,
      accentTextTheme: _buildTextTheme(base.accentTextTheme, cDrawThisBrown),
      textTheme: _buildTextTheme(base.textTheme, cDrawThisBrown),
    );
  }

  TextTheme _buildTextTheme(TextTheme base, Color color) {
    return base
        .copyWith(
          headline: base.headline.copyWith(
            fontWeight: FontWeight.w500,
          ),
          title: base.title.copyWith(fontSize: 18.0),
          caption: base.caption.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
          ),
        )
        .apply(
          fontFamily: 'Rubik',
          displayColor: color,
          bodyColor: color,
        );
  }
}

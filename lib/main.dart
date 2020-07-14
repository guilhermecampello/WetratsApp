import 'package:flutter/material.dart';
import 'layout.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show get;
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'pages/treinos.dart';
import 'pages/dividas.dart';
import 'pages/performances.dart';
import 'pages/grafico.dart';
import 'pages/competicoes.dart';
import 'pages/ranking.dart';


void main() => runApp(Wetrats());

final key = new GlobalKey<LoginPageState>();

class Wetrats extends StatelessWidget {
  // This widget is the root of your application.
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(), 
    HomePage.tag: (context) => HomePage(),
    TreinosPage.tag: (context) => TreinosPage(),
    DividasPage.tag: (context) => DividasPage(),
    PerformancesPage.tag: (context) => PerformancesPage(),
    GraficoPage.tag: (context) => GraficoPage(),
    CompeticoesPage.tag: (context) => CompeticoesPage(),
    RankingPage.tag: (context) => RankingPage()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        title: 'Wetrats',
        theme: ThemeData(
          iconTheme: IconThemeData(color: Layout.secondary()),
          cursorColor: Layout.secondary(),
          textSelectionColor: Layout.secondary(),
          focusColor: Layout.secondary(),
          toggleableActiveColor: Layout.secondary(),
          highlightColor: Layout.secondary(),
          primaryColorDark: Layout.primary(),
          accentColor: Layout.secondary(),
          textTheme : TextTheme(
            headline: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold),
            title: TextStyle(
              fontSize: 36, 
              fontStyle: FontStyle.italic, color: Colors.yellow[600]),
            body1: TextStyle(
              fontSize: 14) 
          )
        ),
      home: LoginPage(key: key),
      routes: routes,

    );
  }
}


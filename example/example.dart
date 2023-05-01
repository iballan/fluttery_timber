

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttery_timber/debug_tree.dart';
import 'package:fluttery_timber/timber.dart';

import 'crashlytics_timber_tree.dart';

void main() {
  _setupLogger();
  runApp(MyApp());
}

void _setupLogger() {
  if (kDebugMode) {
    Timber.plantTree(DebugTree());
  } else {
    Timber.plantTree(CrashlyticsTimberTree());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
      ),
    );
  }
}


class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    Timber.i("init MainPage");
    _logErrorHere();
  }

  void _logErrorHere() {
    try {
      int strangeNumber = 5 ~/ 0;
      Timber.i("This is a strange number $strangeNumber");
    } catch (e, stack) {
      Timber.e("Got an error here", error: e, stackTrace: stack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
      ),
    );
  }
}

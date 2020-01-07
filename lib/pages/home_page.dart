import 'dart:developer';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget{
  HomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> 
{
  Map<String, String> _databaseList = new Map();

  @override
  void initState() {
    super.initState();
    log("Inited state");
  }

  Widget get _llista {
    
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Send to database"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: _llista
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: _databaseUpdate,
        tooltip: 'Increment',
        child: Icon(Icons.cloud_download),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  void _databaseUpdate() {
    DatabaseReference dbref = FirebaseDatabase.instance.reference().root();
    dbref.onValue.listen(_databaseData);
  }

  void _databaseData(Event ev) {
    DataSnapshot snapshot = ev.snapshot;
      log("Recieved data. Snapshot type is " + snapshot.value.runtimeType.toString());
      if (snapshot.value.runtimeType != String) {
        Map<dynamic, dynamic> list = snapshot.value as Map<dynamic, dynamic>;
        log("Not string");
        list.forEach((k, v) {
          log("Key type " + k.runtimeType.toString());
          log("Value type " + k.runtimeType.toString());
        });
      }
  }
}
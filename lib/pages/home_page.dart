import 'dart:developer';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
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

class _HomePageState extends State<HomePage> {
  List<DatabaseElement> _databaseList = new List();

  @override
  void initState() {
    super.initState();
    log("Inited state");
    DatabaseReference dbref = FirebaseDatabase.instance.reference().root();
    dbref.onValue.listen(_databaseData);
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
        child: ListView.builder(
          itemExtent: 80,
          itemCount: _databaseList.length,
          itemBuilder: (BuildContext ctx, int index) => DatabaseListItem(_databaseList[index].key, _databaseList[index].value),
        )
      ),
    );
  }

  void _databaseData(Event ev) {
    DataSnapshot snapshot = ev.snapshot;
    log("Recieved data. Snapshot type is " +
        snapshot.value.runtimeType.toString());
    if (snapshot.value.runtimeType != String) {
      Map<dynamic, dynamic> list = snapshot.value as Map<dynamic, dynamic>;
      List<DatabaseElement> elements = new List();
      List<Widget> widgets = new List();
      list.forEach((k, v) {
        log(k + ": " + v);
        elements.add(new DatabaseElement(k, v));
        widgets.add(new DatabaseListItem(k, v));
      });

      log("Total items of data list are: " + list.length.toString());
      log("Total items of widget list are: " + widgets.length.toString());

      this.setState(() {
        _databaseList = elements;
      });
    }
  }
}

class DatabaseElement {
  final String key;
  final String value;

  DatabaseElement(this.key, this.value);
}

class DatabaseListItem extends StatelessWidget {
  final String title;
  final String content;

  DatabaseListItem(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: Card(
          child: ListTile(
            leading: Icon(
              Icons.event_note,
              size: 40.0,
            ),
            title: Text(this.title),
            subtitle: Text(this.content),
          ),
        ),
        // child: Text(this.content, style: TextStyle(color: Colors.black),),
      ),
      height: 50,
      width: 50,
    );
  }
}

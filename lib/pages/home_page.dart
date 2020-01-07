import 'dart:developer';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_exemple/widgets/database_list_item.dart';
import 'package:firebase_exemple/widgets/form.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<DatabaseElement> _databaseList = new List();
  final _animatedListKey = new GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    log("Inited state");
    DatabaseReference dbref = FirebaseDatabase.instance.reference().root();
    dbref.onValue.listen(_databaseData);
  }

  @override
  Widget build(BuildContext context) {
    log("Showing " + _databaseList.length.toString() + " items");
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Send to database"),
      ),
      body: Center(
        child: ListView.builder(
          itemExtent: 80,
          itemCount: _databaseList.length,
          itemBuilder: (BuildContext ctx, int index) => DatabaseListItem(ctx, _databaseList[index]),
        ),
        // child: AnimatedList(
        //   key: _animatedListKey,
        //   initialItemCount: _databaseList.length,
        //   itemBuilder: (BuildContext context,int index,Animation<double> animation) {
        //     log("Drawing item with index " + index.toString());
        //     return SlideTransition(
        //       position: animation.drive(Tween(
        //           begin: Offset.fromDirection(1),
        //           end: Offset.fromDirection(0))),
        //       child: DatabaseListItem(context, _databaseList[index]),
        //     );
        //   },
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.note_add),
        onPressed: () {
          log("Add note");
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DatabaseForm.newItem(context);
            },
          );
        },
      ),
    );
  }

  void _databaseData(Event ev) {
    DataSnapshot snapshot = ev.snapshot;
    log("Recieved data. Snapshot type is " +
        snapshot.value.runtimeType.toString());

    Map<dynamic, dynamic> list = snapshot.value as Map<dynamic, dynamic>;
    List<DatabaseElement> elements = new List();
    if (list != null)
      list.forEach((k, v) {
        elements.add(new DatabaseElement(k, v["title"], v["value"]));
      });

    log("Total items of data list are: " + elements.length.toString());

    this.setState(() {
      _databaseList = elements;
    });
  }
}

class DatabaseElement {
  String key;
  String title;
  String value;

  DatabaseElement(this.key, this.title, this.value);
}

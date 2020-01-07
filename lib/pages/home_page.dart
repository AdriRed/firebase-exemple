import 'dart:developer';
import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_exemple/widgets/form.dart';
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
          itemBuilder: (BuildContext ctx, int index) => DatabaseListItem(ctx, _databaseList[index]),
        ),
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
    log("Recieved data. Snapshot type is " + snapshot.value.runtimeType.toString());
    
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

class DatabaseListItem extends StatelessWidget {
  String get title {
    return element.title;
  }
  String get content {
    return element.value;
  }
  final int lettersLimit = 30;
  final DatabaseElement element;
  final BuildContext context;
  DatabaseListItem(this.context, this.element);

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
              subtitle: Text(this.content.length >= lettersLimit + 3 ? this.content.substring(0, lettersLimit) + "..." : this.content),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 30,
                ),
                color: Colors.red,
                onPressed: () => this.alertDelete(context),
              )),
        ),
        onTap: () {
          log("Edit element with title: " + this.title);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return DatabaseForm.edit(context, element);
            },
          );
        },
      ),
      height: 50,
      width: 50,
    );
  }

  void alertDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text("Really do you want to delete this item?"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Nope",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              log("Not deleted");
              Navigator.pop(context);
            },
          ),
          FlatButton(
              child: Text(
                "Yea boi",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                deleteItem();
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  void deleteItem() {
    FirebaseDatabase.instance.reference().child(element.key).remove().then(
      (el) {
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Deleted note " + element.title),)
        );
      }
    );
  }
}

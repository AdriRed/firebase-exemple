import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_exemple/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'form.dart';

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
              subtitle: Text(this.content.length >= lettersLimit + 3
                  ? this.content.substring(0, lettersLimit) + "..."
                  : this.content),
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
    FirebaseDatabase.instance.reference().child(element.key).remove();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Deleted note " + element.title),
    ));
  }
}

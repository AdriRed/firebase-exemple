import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_exemple/pages/home_page.dart';
import 'package:flutter/material.dart';

class DatabaseForm extends StatefulWidget {
  DatabaseElement element;
  BuildContext context;
  DatabaseForm.newItem(this.context) {
    element = null;
  }

  DatabaseForm.edit(this.context, DatabaseElement element) {
    this.element = element;
  }

  @override
  _DatabaseFormState createState() => _DatabaseFormState(element);
}

class _DatabaseFormState extends State<DatabaseForm> {
  final _formKey = GlobalKey<FormState>();

  DatabaseElement _prevElement;
  DatabaseElement _temporalElement;
  bool isNew;
  bool _locked = true;
  _DatabaseFormState(DatabaseElement element) {
    isNew = element == null;
    _prevElement = element;
    _temporalElement = 
      isNew ?
        new DatabaseElement("", "", "") 
        :
        new DatabaseElement(element.key, element.title, element.value);
  }

  void sendToDatabase() {
    var dbroot = FirebaseDatabase.instance.reference().root();
    Future<void> commit;
    if (isNew) {
      var reference = dbroot.push();
      commit = reference.set(<String, String>{
        "title": _temporalElement.title,
        "value": _temporalElement.value
      });
    } else {
      var reference = dbroot.child(_prevElement.key).reference();
      commit = reference.update({
        "title": _temporalElement.title,
        "value": _temporalElement.value
      });
    }
    commit.then((val) => Navigator.of(widget.context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: _temporalElement.title,
                decoration: InputDecoration(labelText: "Title"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a title.';
                  }
                },
                maxLines: 1,
                enabled: _locked,
                onSaved: (value) => this.setState(() {_temporalElement.title = value;}),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: _temporalElement.value,
                decoration: InputDecoration(labelText: "Note"),
                maxLines: 3,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a value.';
                  }
                },
                enabled: _locked,
                onSaved: (value) => this.setState(() {_temporalElement.value = value;}),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text("Save"),
                onPressed: () {
                  this.setState(() {_locked = !_locked;});
                  final form = _formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    sendToDatabase();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

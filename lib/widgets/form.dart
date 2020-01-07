import 'dart:developer';

import 'package:firebase_exemple/pages/home_page.dart';
import 'package:flutter/material.dart';

class DatabaseForm extends StatefulWidget {
  DatabaseElement element;
  DatabaseForm.newItem() {
    element = null;
  }

  DatabaseForm.edit(DatabaseElement element) {
    this.element = element;
  }

  @override
  _DatabaseFormState createState() => _DatabaseFormState(element);
}

class _DatabaseFormState extends State<DatabaseForm> {
  final _formKey = GlobalKey<FormState>();

  DatabaseElement _temporalElement;

  _DatabaseFormState(DatabaseElement element) {
    _temporalElement = 
      element == null ?
        new DatabaseElement("", "") 
        :
        new DatabaseElement(element.key, element.value);
  }

  void sendToDatabase() {
    log("Send element key: " + _temporalElement.key + ", value: " + _temporalElement.value);
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
                initialValue: _temporalElement.key,
                decoration: InputDecoration(labelText: "Title"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a title.';
                  }
                },
                onSaved: (value) => this.setState(() {_temporalElement.key = value;}),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: _temporalElement.value,
                decoration: InputDecoration(labelText: "Note"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a value.';
                  }
                },
                onSaved: (value) => this.setState(() {_temporalElement.value = value;}),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text("Save"),
                onPressed: () {
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

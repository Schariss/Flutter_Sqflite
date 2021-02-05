import 'dart:async';

import 'package:flutter/material.dart';
import 'database_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class MyItem {
  bool isExpanded;
  final String header;
  final Widget body;

  MyItem(this.isExpanded, this.header, this.body);
}

class _State extends State<HomePage> {
  List<MyItem> _items = new List<MyItem>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name;
  TextEditingController _value;
  TextEditingController _numero;

  @override
  void initState() {
    // Duration d = new Duration(milliseconds: 1000);
    // Timer t = new Timer(d, () => display());
    display();
    _name = new TextEditingController();
    _value = new TextEditingController();
    _numero = new TextEditingController();
  }

  void display() async {
    List<Map<String, dynamic>> rows =
        await DatabaseHelper.instance.rowsdisplayAll();
    print(rows);
    rows.forEach((element) {
      // _name = TextEditingController(text: element["name"]);
      // _value = TextEditingController(text: element["value"].toString());
      // _numero = TextEditingController(text: element["num"].toString());

      MyItem item = new MyItem(
          false,
          element["name"],
          new Row(children: [
            new Container(
              child: new Text(
                  "value is ${element['value']}, and num is ${element['num']}"),
              padding: EdgeInsets.all(10.0),
            ),
            new IconButton(
                icon: Icon(Icons.update),
                color: Colors.redAccent,
                tooltip: 'update',
                onPressed: () {
                  print('Not Working yet');
                  //         showDialog(
                  //             context: context,
                  //             builder: (BuildContext context) {
                  //               return AlertDialog(
                  //                 content: Stack(
                  //                   overflow: Overflow.visible,
                  //                   children: <Widget>[
                  //                     Positioned(
                  //                       right: -40.0,
                  //                       top: -40.0,
                  //                       child: InkResponse(
                  //                         onTap: () {
                  //                           Navigator.of(context).pop();
                  //                         },
                  //                         child: CircleAvatar(
                  //                           child: Icon(Icons.close),
                  //                           backgroundColor: Colors.red,
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     Form(
                  //                       key: _formKey,
                  //                       child: Column(
                  //                         mainAxisSize: MainAxisSize.min,
                  //                         children: <Widget>[
                  //                           Padding(
                  //                             padding: EdgeInsets.all(8.0),
                  //                             child: TextFormField(
                  //                               controller: _name,
                  //                               decoration: new InputDecoration(
                  //                                   labelText: 'Enter name'),
                  //                             ),
                  //                           ),
                  //                           Padding(
                  //                             padding: EdgeInsets.all(8.0),
                  //                             child: TextFormField(
                  //                                 controller: _value,
                  //                                 decoration: new InputDecoration(
                  //                                     labelText: 'Enter value')),
                  //                           ),
                  //                           Padding(
                  //                             padding: EdgeInsets.all(8.0),
                  //                             child: TextFormField(
                  //                                 controller: _numero,
                  //                                 decoration: new InputDecoration(
                  //                                     labelText: 'Enter num')),
                  //                           ),
                  //                           Padding(
                  //                             padding: const EdgeInsets.all(8.0),
                  //                             child: RaisedButton(
                  //                               child: Text("Add details"),
                  //                               onPressed: () {
                  //                                 if (_formKey.currentState
                  //                                     .validate()) {
                  //                                   _formKey.currentState.save();
                  //                                   MyItem item = new MyItem(
                  //                                       false,
                  //                                       _name.text,
                  //                                       new Container(
                  //                                         child: new Text(
                  //                                             "value is ${_value.text}, and num is ${_numero.text}"),
                  //                                         padding: EdgeInsets.all(10.0),
                  //                                       ));
                  //                                   setState(() {
                  //                                     DatabaseHelper.instance.update({
                  //                                       "name": _name.text,
                  //                                       "value": int.parse(_value.text),
                  //                                       "num":
                  //                                           double.parse(_numero.text)
                  //                                     });
                  //                                     //_items[_items.indexOf(item)] = ;
                  //                                   });
                  //                                   Navigator.of(context).pop();
                  //                                 }
                  //                               },
                  //                             ),
                  //                           )
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               );
                  //             });
                  //
                })
          ]));
      setState(() {
        _items.add(item);
      });
    });
  }

  void _insert(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller: _name,
                            decoration:
                                new InputDecoration(labelText: 'Enter name')),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller: _value,
                            decoration:
                                new InputDecoration(labelText: 'Enter value')),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller: _numero,
                            decoration:
                                new InputDecoration(labelText: 'Enter num')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Add details"),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              MyItem item = new MyItem(
                                  false,
                                  _name.text,
                                  new Container(
                                    child: new Text(
                                        "value is ${_value.text}, and num is ${_numero.text}"),
                                    padding: EdgeInsets.all(10.0),
                                  ));
                              setState(() {
                                DatabaseHelper.instance.insert({
                                  "name": _name.text,
                                  "value": int.parse(_value.text),
                                  "num": double.parse(_numero.text)
                                });
                                _items.add(item);
                              });
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  ExpansionPanel _createItem(MyItem item) {
    return new ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return new Container(
            padding: EdgeInsets.all(5.0),
            child: new Text("${item.header}"),
          );
        },
        body: item.body,
        isExpanded: item.isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Database Test'),
      ),
      body: new Column(children: [
        new Text("List of elements",
            style: TextStyle(
                fontSize: 25.0, height: 2.0, color: Colors.redAccent)),
        Expanded(
            child: SizedBox(
          height: 200,
          child: new Container(
              // padding: new EdgeInsets.all(20.0),
              margin: EdgeInsets.only(top: 20.0),
              child: new ListView(children: <Widget>[
                new ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _items[index].isExpanded = !_items[index].isExpanded;
                    });
                  },
                  children: _items.map((e) => _createItem(e)).toList(),
                ),
              ])),
        ))
      ]),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => _insert(context),
        tooltip: 'Add',
        child: new Icon(Icons.add),
      ),
    );
  }
}

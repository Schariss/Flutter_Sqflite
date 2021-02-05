import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'item.dart';

class HomePage extends StatefulWidget {
  @override
  _State createState() => new _State();
}

class _State extends State<HomePage> {
  List<MyItem> _items = new List<MyItem>();
  final _formKey = GlobalKey<FormState>();
  final _updatedformKey = GlobalKey<FormState>();
  TextEditingController _name;
  TextEditingController _value;
  TextEditingController _numero;
  TextEditingController _updateName;
  TextEditingController _updateValue;
  TextEditingController _updateNumero;

  @override
  void initState() {
    _name = new TextEditingController();
    _value = new TextEditingController();
    _numero = new TextEditingController();
    display();
  }

  void display() async {
    List<Map<String, dynamic>> rows =
        await DatabaseHelper.instance.rowsdisplayAll();
    // print(rows);
    rows.forEach((element) {
      MyItem item = new MyItem(
          id: element["id"],
          isExpanded: false,
          name: element["name"],
          valeur: element["value"],
          numero: element["num"]);
      setState(() {
        _items.add(item);
      });
    });
  }

  void buildDialog(
      String submit,
      GlobalKey<FormState> formKey,
      TextEditingController name,
      TextEditingController value,
      TextEditingController numero,
      Function func) {
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
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller: name,
                            decoration:
                                new InputDecoration(labelText: 'Enter name')),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller: value,
                            decoration:
                                new InputDecoration(labelText: 'Enter value')),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextFormField(
                            controller: numero,
                            decoration:
                                new InputDecoration(labelText: 'Enter num')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            RaisedButton(child: Text(submit), onPressed: func),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _insert() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      MyItem item = new MyItem(
          isExpanded: false,
          name: _name.text,
          valeur: int.parse(_value.text),
          numero: double.parse(_numero.text));
      int id = await DatabaseHelper.instance.insert({
        "name": _name.text,
        "value": int.parse(_value.text),
        "num": double.parse(_numero.text)
      });
      setState(() {
        _formKey.currentState.reset();
        item.id = id;
        _items.add(item);
      });
      Navigator.of(context).pop();
    }
  }

  void _onCreate(BuildContext context) {
    buildDialog(
        "Add details", _formKey, _name, _value, _numero, () => _insert());
  }

  void _update(MyItem element) {
    String name;
    int value;
    double numero;
    if (_updatedformKey.currentState.validate()) {
      _updatedformKey.currentState.save();
      name = _updateName.text;
      value = int.parse(_updateValue.text);
      numero = double.parse(_updateNumero.text);

      DatabaseHelper.instance.update(
          {"id": element.id, "name": name, "value": value, "num": numero});
      setState(() {
        _items[_items.indexOf(element)].name = name;
        _items[_items.indexOf(element)].valeur = value;
        _items[_items.indexOf(element)].numero = numero;

        _updatedformKey.currentState.reset();
        Navigator.of(context).pop();
      });
    }
  }

  Widget updateIconButton(MyItem element) {
    return new IconButton(
        //key: Key('$i'),
        icon: Icon(Icons.update),
        color: Colors.redAccent,
        tooltip: 'update',
        onPressed: () {
          _updateName = TextEditingController(text: element.name);
          _updateValue = TextEditingController(text: element.valeur.toString());
          _updateNumero =
              TextEditingController(text: element.numero.toString());
          buildDialog("Update details", _updatedformKey, _updateName,
              _updateValue, _updateNumero, () => _update(element));
        });
  }

  Widget deleteIconButton(MyItem item) {
    return new IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          var deleted = DatabaseHelper.instance.delete(item.id);
          print('successfully deleted $deleted');
          setState(() {
            _items.removeAt(_items.indexOf(item));
          });
        });
  }

  ExpansionPanel _createItem(MyItem item) {
    return new ExpansionPanel(
        headerBuilder: (BuildContext context, bool isExpanded) {
          return Container(
            padding: EdgeInsets.all(20.0),
            child: new Text(
              "${item.name}",
              style: new TextStyle(fontSize: 16.0),
            ),
          );
        },
        body: new Center(
            child: new Row(children: [
          Container(
            child: MyItem.buildContent(item.valeur, item.numero),
            padding: EdgeInsets.all(10.0),
          ),
          updateIconButton(item),
          deleteIconButton(item)
        ])),
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
                fontSize: 30.0, height: 2.0, color: Colors.redAccent)),
        Expanded(
            child: SizedBox(
          height: 200,
          child: new Container(
              //width: 300,
              // padding: new EdgeInsets.all(20.0),
              margin: EdgeInsets.only(top: 20.0),
              child: new ListView(children: <Widget>[
                new ExpansionPanelList(
                  dividerColor: Colors.redAccent,
                  animationDuration: new Duration(milliseconds: 400),
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
        onPressed: () => _onCreate(context),
        tooltip: 'Add',
        child: new Icon(Icons.add),
      ),
    );
  }
}

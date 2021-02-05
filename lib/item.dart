import 'package:flutter/material.dart';

class MyItem {
  bool isExpanded;
  int id;
  String name;
  int valeur;
  double numero;

  MyItem({this.id, this.isExpanded, this.name, this.valeur, this.numero});

  static Widget buildContent(int value, double numero) {
    return new Text("value is $value, and num is $numero");
  }
}

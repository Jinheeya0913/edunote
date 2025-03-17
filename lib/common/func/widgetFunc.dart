import 'package:flutter/material.dart';

List<Widget> createTextListWithString (List<String> stringList){
  final itemList = <Widget>[];

  for(var value in stringList){
    var item = Center(child: Text(value));
    itemList.add(item);
  }

  return itemList;
}
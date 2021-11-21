import 'package:crud/Model/item.dart';
import 'package:crud/Model/shopping_list.dart';
import 'package:crud/database/dbhelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dialog/item_dialog.dart';
import 'dialog/shopping_list_dialog.dart';

class ListDetailScreen extends StatefulWidget {
  final ShoppingList list;
  ListDetailScreen({Key? key, required this.list}) : super(key: key);

  @override
  _ListDetailScreenState createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  DbHelper dbHelper = DbHelper();
  List<Item> listItem = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dbHelper.getListItem(widget.list.id).then((value){
      setState(() {
        listItem = value;
        print(listItem.toString());
      });
    });
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.list.name),
        ),
        body: ListView.builder(
            itemCount: listItem.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 2.0,
                child: ListTile(
                  title: Text(listItem[index].name),
                  subtitle: Text(
                      'Quantity: ${listItem[index].quantity} - Note:  ${listItem[index].note}'),
                ),
              );
            }),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showDialog(context: context, builder: (BuildContext context) => ItemDialog(context,widget.list.id).create());
            }
        )
    );
  }
}

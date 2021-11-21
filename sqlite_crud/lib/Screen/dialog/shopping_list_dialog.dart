import 'package:crud/Model/shopping_list.dart';
import 'package:crud/database/dbhelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShoppingListDialog {
  final BuildContext context;
  final ShoppingList list;
  final bool isAddNewList;

  ShoppingListDialog(this.context, this.list, this.isAddNewList);

  final edtNameController = TextEditingController();
  final edtPriorityController = TextEditingController();
  Widget create() {
    DbHelper dbHelper = DbHelper();
    if (!isAddNewList) {
      edtNameController.text = list.name;
      edtPriorityController.text = list.priority.toString();
    }
    return AlertDialog(
        title: Text(isAddNewList ? 'New shopping list' : 'Edit shopping list'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        content: SingleChildScrollView(
          child: Column(children:[
            TextField(
                controller: edtNameController,
                decoration: InputDecoration(hintText: 'Shopping List Name')),
            TextField(
              controller: edtPriorityController,
              keyboardType: TextInputType.number,
              decoration:
              InputDecoration(hintText: 'Shopping List Priority (1-3)'),
            ),
          ]),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('Save'),
                onPressed: () {
                  list.name = edtNameController.text;
                  list.priority = int.parse(edtPriorityController.text);
                  if(isAddNewList){
                    dbHelper.insertList(list);
                  }
                  else{
                    dbHelper.updateList(list);
                  }
                  Navigator.pop(context);
                },
              ),
              Padding(padding: EdgeInsets.only(left: 20)),
              ElevatedButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
    );
  }
}
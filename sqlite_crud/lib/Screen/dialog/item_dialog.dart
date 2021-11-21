import 'package:crud/Model/item.dart';
import 'package:crud/Model/shopping_list.dart';
import 'package:crud/database/dbhelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemDialog {
  final BuildContext context;
  final int idList;

  ItemDialog(this.context, this.idList);

  final edtNameController = TextEditingController();
  final edtQuantityController = TextEditingController();
  final edtNoteController = TextEditingController();
  Widget create() {
    DbHelper dbHelper = DbHelper();

    return AlertDialog(
      title: Text('New item'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      content: SingleChildScrollView(
        child: Column(children:[
          TextField(
              controller: edtNameController,
              decoration: InputDecoration(hintText: 'Name')),
          TextField(
            controller: edtQuantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Quantity'),
          ),
          TextField(
              controller: edtNoteController,
              decoration: InputDecoration(hintText: 'Note')),
        ]),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                  Item item = Item(-1,idList,edtNameController.text,int.parse(edtQuantityController.text),edtNoteController.text);
                  dbHelper.insertItem(item);
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
import 'package:crud/Model/shopping_list.dart';
import 'package:crud/Screen/dialog/shopping_list_dialog.dart';
import 'package:crud/database/dbhelper.dart';
import 'package:flutter/material.dart';

import 'Screen/list_item_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo SQLite CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DbHelper dbHelper = DbHelper();
  List<ShoppingList> list = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    dbHelper.getList().then((value){
      setState(() {
        list = value;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo SQLite CRUD"),
      ),
      body: ListView.builder(
        itemCount: list.length,
          itemBuilder: (BuildContext context, int position){
          return Dismissible(
            key: Key(list[position].name),
            onDismissed: (direction){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted : ${list[position].name}")));
              dbHelper.deleteList(list[position]);
              setState(() {
                list.removeAt(position);
              });
            },
            child: Card(
              elevation: 2.0,
              child: ListTile(
                title: Text(list[position].name + " id : " + list[position].id.toString()),
                leading: CircleAvatar(
                  child: Text(list[position].priority.toString()),
                ),
                onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ListDetailScreen(list: list[position])));
                },
                trailing: IconButton(
                icon: Icon(Icons.edit),
                  onPressed: () {
                      showDialog(context: context, builder: (BuildContext context) =>
                          ShoppingListDialog(context, list[position], false).create());
                  },
                ),
              ),
            ),
          );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(context: context, builder: (BuildContext context) => ShoppingListDialog(context, ShoppingList(-1,"",0), true).create());
        }
      )
    );
  }

}


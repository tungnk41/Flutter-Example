import 'package:crud/Model/item.dart';
import 'package:crud/Model/shopping_list.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  final int version = 1;
  Database? _db;

  Future testDb() async {
    Database db = await openDb();
    await db.execute('INSERT INTO list_table VALUES (0, "Fruit", 2)');
    await db.execute(
        'INSERT INTO item_table VALUES (0, 0, "Apples", "2 Kg", "Better if they are green")');
    List lists = await db.rawQuery('select * from list_table');
    List items = await db.rawQuery('select * from item_table');
    print(lists[0].toString());
    print(items[0].toString());
  }

  Future<Database> openDb() async{
     _db ??= await openDatabase(
          join(await getDatabasesPath(),'shopping.db'),
          onCreate: (database,version) {
            String queryCreateTableList =
                "CREATE TABLE list_table (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,priority INTEGER)";
            String queryCreateTableItems =
                "CREATE TABLE item_table (id INTEGER PRIMARY KEY AUTOINCREMENT, idList INTEGER, name TEXT, quantity INTEGER, note TEXT, FOREIGN KEY(idList) REFERENCES list_table(id))";
            database.execute(queryCreateTableList);
            database.execute(queryCreateTableItems);

          },
          version: version
      );
    return _db!;
  }

  Future<int> insertList(ShoppingList list) async {
    Database db = await openDb();
    int id = await db.insert(
      'list_table',
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> updateList(ShoppingList list) async {
    Database db = await openDb();
    int id = await db.update(
      'list_table',
      list.toMap(),
      where: 'id = ?', whereArgs: [list.id],
      conflictAlgorithm: ConflictAlgorithm.replace
    );
    return id;
  }

  Future<List<ShoppingList>> getList() async {
    Database db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query('list_table');
    return List.generate(maps.length, (i) {
      return ShoppingList(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['priority'],
      );
    });
  }

  Future<int> deleteList(ShoppingList list) async {
    Database db = await openDb();
    int result = await db.delete("item_table", where: "idList = ?", whereArgs: [list.id]);
    result = await db.delete("list_table", where: "id = ?", whereArgs: [list.id]);
    return result;
  }


  Future<int> insertItem(Item item) async {
    Database db = await openDb();
    int id = await db.insert(
      'item_table',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<Item>> getListItem(int idList) async {
    Database db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query('item_table', where: 'idList = ?', whereArgs: [idList]);
    return List.generate(maps.length, (i) {
      return Item(
        maps[i]['id'],
        maps[i]['idList'],
        maps[i]['name'],
        maps[i]['quantity'],
        maps[i]['note'],
      );
    });
  }



}
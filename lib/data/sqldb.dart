import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:to_do_app/models/tasks_model.dart';

class Sqldb {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initialDatabase();
    return _database;
  }

  //? إنشاء قاعدة البيانات
  initialDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo.db');
    Database database = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);

    return database;
  }

  //? عند إنشاء قاعدة البيانات
  _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE tasks (
              id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
              task TEXT NOT NULL,
              content TEXT NOT NULL,
              date TEXT,
              time TEXT,
              priority TEXT,
              isDone INTEGER
              )
               ''');
  }

  //? عند ترقية قاعدة البيانات
  _onUpgrade(Database db, int oldVersion, int newVersion) {
    // _onCreate(db, newVersion);

    // Execute the first ALTER TABLE statement
//      db.execute('''
//       ALTER TABLE tasks ADD COLUMN content TEXT
//     ''');

//     // Execute the second ALTER TABLE statement
//      db.execute('''
//       ALTER TABLE tasks ADD COLUMN time TEXT
//     ''');
// print('upgrade================================================================');
  }

  //! قراءة البيانات
  Future<List<Map<String, dynamic>>> readData(String sql) async {
    Database? mydb = await database;
    List<Map<String, dynamic>> response = await mydb!.rawQuery(sql);
    return response;
  }

  //! إدخال البيانات
  Future<int> insertData(TasksModel task) async {
    Database? mydb = await database;
    int response = await mydb!.rawInsert(
      'INSERT INTO tasks (task, content, date, time, priority) VALUES (?, ?, ?, ?, ?)',
      [task.title, task.content, task.date, task.time,task.priority],
    );
    return response;
  }

  //! حذف البيانات
  Future<int> deleteData(int id) async {
    Database? mydb = await database;
    int response =
        await mydb!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]);
    return response;
  }

  //! تحديث البيانات
   //! تحديث البيانات
  Future<int> updateData(String sql, List<dynamic> arguments) async {
    Database? mydb = await database;
    int response = await mydb!.rawUpdate(sql, arguments);
    return response;
  }


  //! Delete all tasks
  Future<int> deleteAll() async {
    Database? mydb = await database;
    int response = await mydb!.rawDelete('DELETE FROM tasks');
    return response;
  }
}

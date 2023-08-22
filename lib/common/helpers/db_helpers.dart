import 'package:flutter/material.dart';
import 'package:management/common/models/task_model.dart';
import 'package:management/common/widgets/custom_alert.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  static sql.Database? _db;

  static Future<void> createTables(_db) async {
    await _db.execute(
      'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, description STRING, isCompleted INTEGER, startTime STRING, endTime STRING, remind INTEGER, repeat STRING)',
    );

    await _db.execute(
      'CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT DEFAULT 0, isVerified INTEGER)',
    );
  }

  static Future<void> init(BuildContext context) async {
    if (_db != null) {
      return;
    }
    try {
      final dbPath = await sql.getDatabasesPath();
      _db = await sql.openDatabase(
        '${dbPath}tasks.db',
        onCreate: (db, version) async {
          await createTables(db);
        },
      );
    } catch (e) {
      if (context.mounted) {
        CustomCupertinoAlertDialog.show(
          context,
          "Alert",
          "Error while creating database $e in the device storage",
        );
      }
    }
  }

  static Future<int> createItem(Task task) async {
    final db = DBHelper._db;
    final result = await db!.insert(
      'tasks',
      task.toJson(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return result;
  }

  // fetch all tasks from database
  static Future<List<Task>> getItems() async {
    final db = DBHelper._db;
    final result = await db!.query('tasks');
    return result.map((json) => Task.fromJson(json)).toList();
  }

  // fetch single task from database
  static Future<Task> getItem(int id) async {
    final db = DBHelper._db;
    final result = await db!.query(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return Task.fromJson(result.first);
  }
  static Future<int> updateTask(int id, String title, String description, int isCompleted, String date, String startTime, String endTime, int remind, String repeat) async {
    final db = DBHelper._db;
    final result = await db!.update(
      'tasks',
      {
        'title': title,
        'description': description,
        'isCompleted': isCompleted,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'remind': remind,
        'repeat': repeat,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }


  static Future<int> deleteItem(int id) async {
    final db = DBHelper._db;
    final result = await db!.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  static Future<int> deleteAll(BuildContext context) async {
    final db = DBHelper._db;
    try {
      db!.delete('tasks');
    } catch (e) {
      if (context.mounted) {
        CustomCupertinoAlertDialog.show(
          context,
          "Alert",
          "Error while deleting database $e ",
        );
      }
    }
    return 0;
  }

  static Future<int> createUser(int isVerified) async {
    final db = DBHelper._db;
    final result = await db!.insert(
      'user',
      {
        'id': 0,
        'isVerified': isVerified,
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return result;
  }

  static Future<List<Map<String, dynamic>>> getUser() async {
    final db = DBHelper._db;
    final result = await db!.query('user', orderBy: 'id');
    return result;
  }
}

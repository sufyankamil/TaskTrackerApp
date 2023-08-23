import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:management/common/models/task_model.dart';
import 'package:management/common/widgets/custom_alert.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  static sql.Database? _db;

  static Future<void> createTables(sql.Database database) async {
    await database.execute(
      'CREATE TABLE todo(id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, description TEXT, isCompleted INTEGER, date STRING, startTime STRING, endTime STRING, remind INTEGER, repeat STRING)',
    );

    await database.execute(
      'CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT DEFAULT 0, isVerified INTEGER)',
    );
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'todo',
      version: 1,
      onCreate: (db, version) async {
        await createTables(db);
      },
    );
  }

  static Future<int> createItem(Task task) async {
    try {
      final db = DBHelper.db();
      final result = await db.then((value) async {
        final result = await value.insert(
          'todo',
          task.toJson(),
          conflictAlgorithm: sql.ConflictAlgorithm.replace,
        );
        return result;
      });
      print('---->> $result');
      print(result.toString());
      return result;
    } catch (e) {
      print('----');
      if (kDebugMode) {
        print(e);
      }
      return 0;
    }
  }

  // fetch all todo from database
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = DBHelper.db();
    return db.then((value) async {
      final result = await value.query('todo', orderBy: 'id DESC');
      return result;
    });
  }

  // fetch single task from database
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = DBHelper.db();
    final result = await db.then((value) async {
      final result = await value.query(
        'todo',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return result;
    });
    return result;
  }

  static Future<int> updateTask(
    int id,
    String title,
    String description,
    int isCompleted,
    String date,
    String startTime,
    String endTime,
    int remind,
    String repeat,
  ) async {
    final database = DBHelper.db();
    final data = {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'remind': remind,
      'repeat': repeat,
    };

    final result = database.then((value) async {
      final result = await value.update(
        'todo',
        data,
        where: 'id = ?',
        whereArgs: [id],
      );
      return result;
    });
    return result;
  }

  static Future<int> deleteItem(int id) async {
    final db = DBHelper._db;
    final result = await db!.delete(
      'todo',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  static Future<int> deleteAll(BuildContext context) async {
    final db = DBHelper._db;
    try {
      db!.delete('todo');
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
    final db = await DBHelper.db();
    final result = await db.insert(
      'user',
      {
        'id': 1,
        'isVerified': isVerified,
      },
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return result;
  }

  static Future<List<Map<String, dynamic>>> getUser() async {
    final db = DBHelper.db();
    return db.then((value) async {
      final result = await value.query('user');
      return result;
    });
  }
}

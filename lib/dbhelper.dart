import 'dart:io';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class Exercise {
  static const repeated = 0;
  static const timed = 1;

  String name;
  int type;
  int min;
  int max;

  Exercise(this.name, this.type, this.min, this.max);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'min': min,
      'max': max
    };
  }

  String desc() {
    String desc = min.toString() + ' to ' + max.toString() + ' ';
    String end = "";
    switch (type) {
      case (Exercise.repeated):
        end = 'repetitions';
        break;
      case (Exercise.timed):
        end = 'seconds';
        break;
    }
    desc += end;
    return desc;
  }
}

class DBHelper {
  static final _dbName = 'ExerciseDB.db';
  static final _dbVersion = 1;
  static final table = 'exercise_table';

  DBHelper._privateConstructor();
  static final DBHelper instance = DBHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _dbName);
    return await openDatabase(path,
        version: _dbVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            type INTEGER NOT NULL,
            min INTEGER NOT NULL,
            max INTEGER NOT NULL
          )
          ''');
  }

  Future<void> insertExercise(Exercise ex) async {
    Database db = await instance.database;
    return await db.insert(table, ex.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Exercise>> allExercises() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Exercise(
        maps[i]['name'],
        maps[i]['type'],
        maps[i]['min'],
        maps[i]['max']
      );
    });
  }
}
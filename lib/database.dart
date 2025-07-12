import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:time_manager/models/task.dart';
import 'package:time_manager/static_data.dart';
import 'package:time_manager/models/user.dart';

import 'models/entry.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _database;

  DatabaseHelper._instance();

  Future<Database> get db async {
    _database ??= await initDb();
    return _database!;
  }

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'taskmanager.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future resetDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'taskmanager.db');

    await deleteDatabase(path);
    _database = null;
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        surname TEXT,
        UNIQUE(name, surname)
      )
    ''');
    await initializeUsers(db);

    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY,
        name TEXT UNIQUE,
        duration INTEGER
      )
    ''');
    await initializeTasks(db);

    await db.execute('''
      CREATE TABLE entries (
        id INTEGER PRIMARY KEY,
        task INTEGER,
        coworker INTEGER,
        timestamp INTEGER,
        note TEXT,
        FOREIGN KEY(task) REFERENCES tasks(id),
        FOREIGN KEY(coworker) REFERENCES users(id)
      )
    ''');
    await initializeEntries(db);
  }

  Future<void> initializeUsers(Database db) async {
    for (User user in usersToAdd) {
      await db.insert('users', user.toJson());
    }
  }

  Future<void> initializeTasks(Database db) async {
    for (Task task in tasksToAdd) {
      await db.insert('tasks', task.toJson());
    }
  }

  Future<void> initializeEntries(Database db) async {
    for (Entry entry in entriesToAdd) {
      await db.insert('entries', entry.toJson());
    }
  }
}
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:time_manager/models/task.dart';
import 'package:time_manager/static_data.dart';
import 'package:time_manager/models/user.dart';

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

    await deleteDatabase(path);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        surname TEXT
      )
    ''');
    await initializeUsers(db);

    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY,
        name TEXT,
        duration INTEGER
      )
    ''');
    await initializeTasks(db);
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
}
import 'package:time_manager/database.dart';
import 'package:time_manager/models/task.dart';

class TaskRepository {
  Future<int> insert(Task task) async {
    final db = await DatabaseHelper.instance.db;
    return await db.insert('tasks', task.toJson());
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await DatabaseHelper.instance.db;
    return await db.query('tasks');
  }

  Future<int> update(Task task) async {
    final db = await DatabaseHelper.instance.db;
    return await db.update('tasks', task.toJson(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<int> delete(int id) async {
    final db = await DatabaseHelper.instance.db;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
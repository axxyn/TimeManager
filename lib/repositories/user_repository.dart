import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/database.dart';
import 'package:time_manager/models/user.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository());

class UserRepository {
  Future<int> insert(User user) async {
    final db = await DatabaseHelper.instance.db;
    return await db.insert('users', user.toJson());
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await DatabaseHelper.instance.db;
    return await db.query('users');
  }

  Future<int> update(User user) async {
    final db = await DatabaseHelper.instance.db;
    return await db.update('users', user.toJson(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> delete(int id) async {
    final db = await DatabaseHelper.instance.db;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
}
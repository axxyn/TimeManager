import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/cache_notifier.dart';
import 'package:time_manager/database.dart';
import 'package:time_manager/models/utils.dart';
import 'package:time_manager/snackbar.dart';

abstract class Repository<T extends Identifiable> with CacheNotifierMixin<T> {
  String get table;
  Ref get ref;

  Future<T?> findBy(List<String> keys, List<String> values) async {
    final db = await DatabaseHelper.instance.db;

    final keysString = keys.map((e) => '$e = ? ').toString();

    final result = await db.query(table, where: keysString, whereArgs: [...values]);
    return result.isNotEmpty ? fromJson(result[0]) : null;
  }

  Future<int> insert(T item) async {
    final db = await DatabaseHelper.instance.db;

    final result = await db.insert(table, item.toJson());
    if (result != 0) {
      Map<String, dynamic> data = {...item.toJson(), 'id': result};
      cache.add(fromJson(data));
      SnackBarController.showSnackBar(snackBarColor: SnackBarColors.add);
    }
    return result;
  }

  Future<List<T>> queryAll() async {
    final db = await DatabaseHelper.instance.db;
    final result = await db.query(table);
    List<T> list = [];
    if (result.isNotEmpty) {
      for (Map<String, dynamic> item in   result) {
        T itemT = fromJson(item);
        list.add(itemT);
        cache.add(itemT);
      }
    }
    return list;
  }

  Future<List<Map<String, dynamic>>> queryIds(List<int> ids) async {
    final db  = await DatabaseHelper.instance.db;
    final result = await db.query(table, where: 'id IN (${List.filled(ids.length, '?').join(',')})', whereArgs: ids);
    if (result.isNotEmpty) {
      for (Map<String, dynamic> item in result) {
        cache.add(fromJson(item));
      }
    }
    return result;
  }

  Future<int> update(T item) async {
    final db = await DatabaseHelper.instance.db;
    final result = await db.update(table, item.toJson(), where: 'id = ?', whereArgs: [item.id]);
    if(result != 0) {
      cache[item.id!] = item;
      SnackBarController.showSnackBar(snackBarColor: SnackBarColors.update);
    }
    return result;
  }

  Future<int> delete(T item) async {
    final db = await DatabaseHelper.instance.db;
    final result = await db.delete(table, where: 'id = ?', whereArgs: [item.id]);
    if(result != 0) {
      cache.remove(item);
      SnackBarController.showSnackBar(snackBarColor: SnackBarColors.delete);
    }
    return result;
  }

  T fromJson(Map<String, dynamic> json);
}
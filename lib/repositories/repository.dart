import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/cache_notifier.dart';
import 'package:time_manager/database.dart';

abstract class Repository<T extends Mappable> with CacheNotifierMixin<T> {
  String get table;
  Ref get ref;

  Future<int> insert(T item) async {
    final db = await DatabaseHelper.instance.db;
    final result = await db.insert(table, item.toJson());
    Map<String, dynamic> data = {...item.toJson(), 'id': result};
    if(result != 0) {
      cache.add(fromJson(data));
      debugPrint('$result Added to cache ${item.toString()}');
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await DatabaseHelper.instance.db;
    final result = await db.query(table);
    return result;
  }

  Future<int> update(T item) async {
    final db = await DatabaseHelper.instance.db;
    final result = await db.update(table, item.toJson(), where: 'id = ?', whereArgs: [item.id]);
    if(result != 0) cache[item.id!] = item;
    return result;
  }

  Future<int> delete(T item) async {
    final db = await DatabaseHelper.instance.db;
    final result = await db.delete(table, where: 'id = ?', whereArgs: [item.id]);
    if(result != 0) cache.remove(item);
    return result;
  }

  T fromJson(Map<String, dynamic> json);
}

mixin Mappable {
  int? id;
  Map<String, dynamic> toJson();
}
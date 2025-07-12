import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/models/utils.dart';

class CacheNotifier<T extends Identifiable> extends StateNotifier<List<T>> {
  CacheNotifier() : super([]);

  void add(T item) {
    if(!state.contains(item)) state = [...state, item];
  }

  void remove(T item) {
    state = [...state].where((e) => e != item).toList();
  }

  void removeAll(List<T> items) {
    state.removeWhere((element) => items.contains(element));
  }

  void clear() {
    state = [];
  }

  void operator []=(int id, T value) {
    state[state.indexWhere((e) => e.id == id)] = value;
  }

  int get length => state.length;

  bool get isEmpty => state.isEmpty;

  List<T> get list => state;
}

mixin CacheNotifierMixin<T extends Identifiable> {
  CacheNotifier<T> get cache;
}
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CacheNotifier<T> extends StateNotifier<List<T>> {
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

  T? operator [](int index) {
    return state[index];
  }

  void operator []=(int index, T value) {
    state[index] = value;
  }

  int get length => state.length;

  bool get isEmpty => state.isEmpty;

  List<T> get list => state;
}

mixin CacheNotifierMixin<T> {
  CacheNotifier<T> get cache;
}
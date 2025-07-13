import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/cache_notifier.dart';
import 'package:time_manager/models/task.dart';
import 'package:time_manager/repositories/repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) => TaskRepository(ref));

final _taskProvider = StateNotifierProvider<CacheNotifier<Task>, List<Task>>((ref) => CacheNotifier<Task>());

final tasksProvider = Provider((ref) {
  final cache = ref.watch(_taskProvider);
  return cache;
});

final taskProvider = Provider.family((ref, int id) {
  final cache = ref.watch(_taskProvider);
  return cache.firstWhere((e) => e.id == id);
});

// final taskFutureProvider = Provider((ref) async {
//   final repository = ref.read(taskRepositoryProvider);
//   final result = await repository.queryAll();
//   return result;
// });

class TaskRepository extends Repository<Task> {
  TaskRepository(this.ref);

  @override
  final Ref ref;

  @override
  String get table => 'tasks';

  @override
  CacheNotifier<Task> get cache => ref.watch(_taskProvider.notifier);

  @override
  Task fromJson(Map<String, dynamic> json) {
    return Task.fromJson(json);
  }
}
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/cache_notifier.dart';
import 'package:time_manager/models/entry.dart';
import 'package:time_manager/repositories/repository.dart';
import 'package:time_manager/repositories/task_repository.dart';
import 'package:time_manager/repositories/user_repository.dart';

final entryRepositoryProvider = Provider<EntryRepository>((ref) => EntryRepository(ref));

final _entryProvider = StateNotifierProvider<CacheNotifier<Entry>, List<Entry>>((ref) => CacheNotifier<Entry>());

final entriesProvider = Provider((ref) {
  final cache = ref.watch(_entryProvider);
  return cache;
});

final entryProvider = Provider.family((ref, int id) {
  final cache = ref.watch(_entryProvider);
  return cache.firstWhere((e) => e.id == id);
});

final entryFutureProvider = Provider((ref) async {
  final repository = ref.read(entryRepositoryProvider);
      final result = await repository.queryAll();
      final usersId = result.map((e) => e.coworker).toList();
      final userRepository = ref.read(userRepositoryProvider);
      await userRepository.queryIds(usersId);

      final tasksId = result.map((e) => e.task).toList();
      final taskRepository = ref.read(taskRepositoryProvider);
      await taskRepository.queryIds(tasksId);
      return result;
});

class EntryRepository extends Repository<Entry> {
  EntryRepository(this.ref);

  @override
  final Ref ref;

  @override
  String get table => 'entries';

  @override
  CacheNotifier<Entry> get cache => ref.watch(_entryProvider.notifier);

  @override
  Entry fromJson(Map<String, dynamic> json) {
    return Entry.fromJson(json);
  }
}
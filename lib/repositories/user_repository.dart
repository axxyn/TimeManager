import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/cache_notifier.dart';
import 'package:time_manager/models/user.dart';
import 'package:time_manager/repositories/repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository(ref));

final _userProvider = StateNotifierProvider<CacheNotifier<User>, List<User>>((ref) => CacheNotifier<User>());

final usersProvider = Provider((ref) {
  final cache = ref.watch(_userProvider);
  return cache;
});

final userProvider = Provider.family((ref, int id) {
  final cache = ref.watch(_userProvider);
  return cache.firstWhere((e) => e.id == id);
});

// final userFutureProvider = Provider((ref) async {
//   final repository = ref.read(userRepositoryProvider);
//   final result = await repository.queryAll();
//   return result;
// });

class UserRepository extends Repository<User> {
  UserRepository(this.ref);

  @override
  final Ref ref;

  @override
  String get table => 'users';

  @override
  CacheNotifier<User> get cache => ref.watch(_userProvider.notifier);

  @override
  User fromJson(Map<String, dynamic> json) {
    return User.fromJson(json);
  }
}
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/future_handler.dart';
import 'package:time_manager/init_future.dart';
import 'package:time_manager/repositories/user_repository.dart';

class UserScreen extends HookConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);

    final future = useInitFuture(() => ref.read(userFutureProvider));

    return FutureHandler(
      future: future,
      child: () => ListView.builder(
        itemCount: users.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              '${users[index].name} ${users[index].surname}',
            ),
          );
        },
      ),
    );
  }
}

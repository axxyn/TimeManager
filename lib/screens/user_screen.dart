import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/future_handler.dart';
import 'package:time_manager/models/user.dart';
import 'package:time_manager/repositories/user_repository.dart';

class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRepository = ref.read(userRepositoryProvider);
    final usersFuture = userRepository.queryAll();

    return FutureHandler(
      future: usersFuture,
      callback: (data) {
        List<Widget> list = [];
        for (Map<String, dynamic> item in data) {
          User user = User.fromJson(item);
          list.add(ListTile(title: Text('${user.name} ${user.surname ?? ''}')));
        }
        return ExpansionTile(title: Text('Pracownicy'), children: list);
      },
    );
  }
}

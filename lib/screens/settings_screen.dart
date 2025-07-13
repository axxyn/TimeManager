import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/database.dart';
import 'package:time_manager/repositories/entry_repository.dart';
import 'package:time_manager/repositories/task_repository.dart';
import 'package:time_manager/repositories/user_repository.dart';
import 'package:time_manager/snackbar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Home', style: TextStyle(fontSize: 40)),
          ElevatedButton(
            onPressed: () async {
              await DatabaseHelper.instance.resetDb();
              await DatabaseHelper.instance.initDb();
              ref.read(taskRepositoryProvider).cache.clear();
              ref.read(userRepositoryProvider).cache.clear();
              ref.read(entryRepositoryProvider).cache.clear();
              SnackBarController.showSnackBar(text: 'Zresetowano baze danych', color: Colors.green);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

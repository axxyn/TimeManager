import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/database.dart';
import 'package:time_manager/repositories/task_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

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
              await DatabaseHelper.instance.db;
              ref.read(taskRepositoryProvider).cache.clear();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor:Colors.green,content: Text('Zresetowano baze danych')));
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

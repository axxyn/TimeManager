import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/future_handler.dart';
import 'package:time_manager/init_future.dart';
import 'package:time_manager/models/task.dart';
import 'package:time_manager/repositories/task_repository.dart';
import 'package:time_manager/screens/task_form.dart';

class TasksScreen extends HookConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final future = useInitFuture(
      () => Future(() async {
        final repository = ref.read(taskRepositoryProvider);
        final result = await repository.queryAll();
        repository.cache.clear();
        for (Map<String, dynamic> item in result) {
          Task task = Task.fromJson(item);
          repository.cache.add(task);
        }
        await Future.delayed(Duration(seconds: 3));
        return result;
      }),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text('Zadania'),
          Expanded(
            child: FutureHandler(
              future: future,
              child: () {
                return ListView.builder(
                  itemCount: tasks.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(tasks[index].id!.toString()),
                      onDismissed: (direction) async {
                        await ref.read(taskRepositoryProvider).delete(tasks[index]);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Usunieto'),
                          ),
                        );
                      },
                      child: ListTile(
                        contentPadding: EdgeInsetsGeometry.zero,
                        title: Text('${tasks[index].name}'),
                        subtitle: Text('Czas: ${tasks[index].duration}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          TaskForm(),
        ],
      ),
    );
  }
}

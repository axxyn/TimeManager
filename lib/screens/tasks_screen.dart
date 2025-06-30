import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/future_handler.dart';
import 'package:time_manager/models/task.dart';
import 'package:time_manager/repositories/task_repository.dart';

class TasksScreen extends HookConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskRepository = ref.read(taskRepositoryProvider);
    final tasksFuture = taskRepository.queryAll();
    // TODO Cache

    final showForm = useState(false);

    return Column(
      children: [
        Text('Zadania'),
        FutureHandler(
          future: tasksFuture,
          callback: (data) {
            return ListView.builder(
              itemCount: data.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Task task = Task.fromJson(data[index]);
                return ListTile(title: Text('${task.name} ${task.duration}'));
              },
            );
          },
        ),
        ElevatedButton(onPressed: () => showForm.value = !showForm.value, child: Text('Dodaj zadanie')),
        Visibility(visible: showForm.value, child: Text('Test')),
      ],
    );
  }
}

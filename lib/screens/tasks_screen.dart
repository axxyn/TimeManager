import 'package:flutter/material.dart';
import 'package:time_manager/future_handler.dart';
import 'package:time_manager/models/task.dart';
import 'package:time_manager/repositories/task_repository.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tasksFuture = TaskRepository().queryAll();

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
                return ListTile(
                  title: Text('${task.name} ${task.duration}'),
                );
              },
            );
          },
        ),
        ElevatedButton(onPressed: () {}, child: Text('Dodaj zadanie')),
      ],
    );
  }
}

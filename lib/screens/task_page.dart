import 'package:flutter/material.dart';
import 'package:time_manager/models/task.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Text('Task details');
  }
}

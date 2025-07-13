import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:time_manager/future_handler.dart';
import 'package:time_manager/models/task.dart';
import 'package:time_manager/repositories/task_repository.dart';
import 'package:time_manager/screens/forms/task_form.dart';
import 'package:time_manager/snackbar.dart';

class TasksScreen extends HookConsumerWidget {
  TasksScreen({super.key});

  final nameController = useTextEditingController();
  final durationController = useTextEditingController();
  final editTaskId = useState<int?>(null);

  final isExpanded = useState(false);

  final _formKey = GlobalKey<FormState>();

  void clearForm() {
    nameController.clear();
    durationController.clear();
    editTaskId.value = null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);

    final future = useState(Future(() async {
      final repository = ref.read(taskRepositoryProvider);
      final result = await repository.queryAll();
      return result;
    }));

    return Column(
      spacing: 8,
      children: [
        Text('Zadania'),
        Expanded(
          child: FutureHandler(
            future: future.value,
            child: () {
              return ListView.builder(
                itemCount: tasks.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Dismissible(
                    key: Key('task${task.id}'),
                    onDismissed: (direction) async {
                      await ref.read(taskRepositoryProvider).delete(task);
                      clearForm();
                    },
                    child: Card(
                      margin: EdgeInsetsGeometry.zero,
                      color: Colors.transparent,
                      child: ListTile(
                        onTap: () {
                          nameController.text = task.name;
                          durationController.text = task.duration.toString();
                          editTaskId.value = task.id;
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(task.name),
                            Opacity(
                              opacity: 0.5,
                              child: Text('Id: ${task.id}'),
                            ),
                          ],
                        ),
                        subtitle: Text('Czas: ${task.duration}'),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Visibility(
                visible: editTaskId.value != null,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    spacing: 8,
                    children: [
                      Text('Edycja: ${editTaskId.value}'),
                      GestureDetector(
                        onTap: () => clearForm(),
                        child: Icon(Icons.undo, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: TaskForm(
                  nameController: nameController,
                  durationController: durationController,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Task task = Task(
                        name: nameController.text,
                        duration: int.parse(durationController.text),
                      );
                      if (editTaskId.value != null) {
                        task = task.copyWith(id: editTaskId.value);
                      }

                      if (editTaskId.value == null) {
                        try {
                          await ref.read(taskRepositoryProvider).insert(task);
                        } on DatabaseException catch (error) {
                          if (error.isUniqueConstraintError()) {
                            SnackBarController.showSnackBar(
                              text: 'Użytkownik już istnieje',
                              color: SnackBarColors.error.color,
                            );
                          }
                        }
                      } else {
                        await ref.read(taskRepositoryProvider).update(task);
                      }
                      clearForm();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

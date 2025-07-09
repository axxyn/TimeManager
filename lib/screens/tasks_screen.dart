import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:time_manager/future_handler.dart';
import 'package:time_manager/init_future.dart';
import 'package:time_manager/models/task.dart';
import 'package:time_manager/repositories/task_repository.dart';
import 'package:time_manager/screens/task_form.dart';
import 'package:time_manager/snackbar.dart';

class TasksScreen extends HookConsumerWidget {
  TasksScreen({super.key});

  final controllers = useState<List<TextEditingController>>(List.generate(2, (i) => TextEditingController()));
  final editTaskId = useState<int?>(null);

  final isExpanded = useState(false);

  final _formKey = GlobalKey<FormState>();

  void resetForm() {
    editTaskId.value = null;
    for(TextEditingController controller in controllers.value) {
      controller.clear();
    }
  }

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
        return result;
      }),
    );

    return Column(
      spacing: 8,
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
                    key: Key('task${tasks[index].id!.toString()}'),
                    onDismissed: (direction) async {
                      final result = await ref.read(taskRepositoryProvider).delete(tasks[index]);
                      if(result != 0) {
                        SnackBarController.showSnackBar(SnackBarColors.delete);
                      }
                      resetForm();
                    },
                    child: Card(
                      margin: EdgeInsetsGeometry.zero,
                      color: Colors.transparent,
                      child: ListTile(
                        onTap: () {
                          controllers.value[0].text = tasks[index].name;
                          controllers.value[1].text = tasks[index].duration.toString();
                          editTaskId.value = tasks[index].id;
                        },
                        title: Text(tasks[index].name),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Czas: ${tasks[index].duration}'),
                            Text('Id: ${tasks[index].id}'),
                          ],
                        ),
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
                      Text('Edycja: ${editTaskId.value.toString()}'),
                      GestureDetector(onTap: () => resetForm(), child: Icon(Icons.undo, color: Colors.red)),
                    ],
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: TaskForm(
                  controllers: controllers.value,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Task task = Task(
                        name: controllers.value[0].text,
                        duration: int.parse(controllers.value[1].text),
                      );
                      if (editTaskId.value != null) {
                        task = task.copyWith(id: editTaskId.value);
                      }

                      try {
                        final result = await ref.read(taskRepositoryProvider).insert(task);
                        if (result != 0) {
                          SnackBarController.showSnackBar(SnackBarColors.add);
                        }
                      } on DatabaseException catch (e) {
                        if(e.isUniqueConstraintError()) {
                          final result = await ref
                              .read(taskRepositoryProvider)
                              .update(task);
                          if (result != 0) {
                            SnackBarController.showSnackBar(SnackBarColors.update);
                          }
                        }
                      }
                      resetForm();
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

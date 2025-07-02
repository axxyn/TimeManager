import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/future_handler.dart';
import 'package:time_manager/init_future.dart';
import 'package:time_manager/models/task.dart';
import 'package:time_manager/repositories/task_repository.dart';

class TasksScreen extends HookConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final repository = ref.read(taskRepositoryProvider);

    final future = useInitFuture(() => ref.read(taskFutureProvider));

    final showForm = useState(false);

    final formKey = GlobalKey<FormState>();
    final nameInputController = TextEditingController();

    return Column(
      children: [
        Text('Zadania'),
        FutureHandler(
          future: future,
          child: () {
            return SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: tasks.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      '${tasks[index].name} ${tasks[index].duration} ${tasks[index].id}',
                    ),
                  );
                },
              ),
            );
          },
        ),
        ElevatedButton(
          onPressed: () => showForm.value = !showForm.value,
          child: Text('Dodaj zadanie'),
        ),
        Visibility(
          visible: showForm.value,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameInputController,
                  decoration: const InputDecoration(labelText: 'Nazwa zadania'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Uzupełnij nazwe';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      showForm.value = false;
                      final result = repository.insert(Task(name: nameInputController.text, duration: 0));
                      if (result != 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Dodano zadanie')),
                        );
                      }
                    }
                  },
                  child: Text('Potwierdź'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

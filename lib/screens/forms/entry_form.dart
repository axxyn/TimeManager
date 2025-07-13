import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/models/entry.dart';
import 'package:time_manager/repositories/entry_repository.dart';
import 'package:time_manager/repositories/task_repository.dart';
import 'package:time_manager/repositories/user_repository.dart';

class EntryForm extends HookConsumerWidget {
  EntryForm({
    super.key,
  });

  final taskId = useState<int?>(null);
  final userId = useState<int?>(null);

  final noteController = useTextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final users = ref.watch(usersProvider);

    return Column(
      spacing: 8,
      children: [
        DropdownButtonFormField(
          onChanged: (value) => taskId.value = value,
          decoration: const InputDecoration(labelText: 'Zadanie'),
          items: tasks.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
        ),
        DropdownButtonFormField(
          onChanged: (value) => userId.value = value,
          decoration: const InputDecoration(labelText: 'Pracownik'),
          items: users.map((e) => DropdownMenuItem(value: e.id, child: Text(e.fullName))).toList(),
        ),
        TextFormField(
          controller: noteController,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 10,
          decoration: const InputDecoration(labelText: 'Notatka'),
        ),
        ElevatedButton(onPressed: () async {
          if (taskId.value != null && userId.value != null) {
            final entry = Entry(task: taskId.value!, coworker: userId.value!, note: noteController.text.isNotEmpty ? noteController.text : null);
            await ref.read(entryRepositoryProvider).insert(entry);
          }
        }, child: Text('Potwierdź')),
      ],
    );
  }
}

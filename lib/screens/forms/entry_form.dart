import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/models/entry.dart';
import 'package:time_manager/models/utils.dart';
import 'package:time_manager/repositories/entry_repository.dart';
import 'package:time_manager/repositories/task_repository.dart';
import 'package:time_manager/repositories/user_repository.dart';

class EntryForm extends HookConsumerWidget {
  EntryForm({super.key});

  final taskId = useState<int?>(null);
  final userId = useState<int?>(null);
  final areaLetter = useState<EntryArea?>(null);
  final areaNumber = useTextEditingController();
  final noteController = useTextEditingController();

  void clearForm() {
    areaNumber.clear();
    noteController.clear();
    taskId.value = null;
    userId.value = null;
    areaLetter.value = null;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final users = ref.watch(usersProvider);

    return Form(
      key: _formKey,
      child: Column(
        spacing: 8,
        children: [
          DropdownButtonFormField(
            value: taskId.value,
            onChanged: (value) => taskId.value = value,
            decoration: const InputDecoration(labelText: 'Zadanie'),
            items: tasks
                .map((e) => DropdownMenuItem(value: e.id, child: Text(e.name)))
                .toList(),
            validator: (value) {
              if (value == null) {
                return 'Wybierz zadanie';
              }
              return null;
            },
          ),
          DropdownButtonFormField(
            value: userId.value,
            onChanged: (value) => userId.value = value,
            decoration: const InputDecoration(labelText: 'Pracownik'),
            items: users
                .map(
                  (e) => DropdownMenuItem(value: e.id, child: Text(e.fullName)),
                )
                .toList(),
            validator: (value) {
              if (value == null) {
                return 'Wybierz pracownika';
              }
              return null;
            },
          ),
          Row(
            spacing: 16,
            children: [
              Flexible(
                child: DropdownButtonFormField(
                  value: areaLetter.value,
                  onChanged: (value) => areaLetter.value = value,
                  decoration: const InputDecoration(labelText: 'Obszar'),
                  items: EntryArea.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Wybierz obszar';
                    }
                    return null;
                  },
                ),
              ),
              Flexible(
                child: TextFormField(
                  controller: areaNumber,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(labelText: 'Numer'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Podaj numer';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          TextFormField(
            controller: noteController,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 10,
            decoration: const InputDecoration(labelText: 'Notatka'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final entry = Entry(
                  task: taskId.value!,
                  coworker: userId.value!,
                  note: noteController.text.isNotEmpty
                      ? noteController.text
                      : null,
                  area: areaLetter.value!,
                  number: int.parse(areaNumber.value.text),
                );
                await ref.read(entryRepositoryProvider).insert(entry);
                clearForm();
              }
            },
            child: Text('Potwierdź'),
          ),
        ],
      ),
    );
  }
}

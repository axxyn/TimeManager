import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/models/task.dart';
import 'package:time_manager/repositories/task_repository.dart';

class TaskFormModel {
  String? name;
  int? duration;

  bool validate() {
    return name != null && duration != null;
  }

  void reset() {
    name = null;
    duration = null;
  }
}

class TaskForm extends ConsumerWidget {
  TaskForm({super.key});

  final model = useState(TaskFormModel());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 8,
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Nazwa zadania'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Podaj nazwe';
              }
              return null;
            },
            onSaved: (value) => model.value.name = value,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: 'Czas'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Podaj czas';
              }
              return null;
            },
            onSaved: (value) => model.value.duration = int.parse(value!),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                final result = await ref.read(taskRepositoryProvider).insert(Task(name: model.value.name!, duration: model.value.duration!));

                if(result != 0) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor:Colors.green, content: Text('Dodano')));
                }
              }
            },
            child: Text('Potwierdź'),
          ),
        ],
      ),
    );
  }
}
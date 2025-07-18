import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskForm extends StatelessWidget {
  const TaskForm({required this.nameController, required this.durationController, required this.onPressed, super.key});

  final TextEditingController nameController;
  final TextEditingController durationController;

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        TextFormField(
          controller: nameController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(labelText: 'Nazwa zadania'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Podaj nazwe';
            }
            return null;
          },
        ),
        TextFormField(
          controller: durationController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(labelText: 'Czas'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Podaj czas';
            }
            return null;
          },
        ),
        ElevatedButton(
          onPressed: onPressed,
          child: Text('Potwierdź'),
        ),
      ],
    );
  }
}

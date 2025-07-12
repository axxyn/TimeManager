import 'package:flutter/material.dart';

class UserForm extends StatelessWidget {
  const UserForm({required this.nameController, required this.surnameController, required this.onPressed, super.key});

  final TextEditingController nameController;
  final TextEditingController surnameController;

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        TextFormField(
          controller: nameController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(labelText: 'Imie'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Podaj imie';
            }
            return null;
          },
        ),
        TextFormField(
          controller: surnameController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(labelText: 'Nazwisko'),
        ),
        ElevatedButton(
          onPressed: onPressed,
          child: Text('Potwierdź'),
        ),
      ],
    );
  }
}

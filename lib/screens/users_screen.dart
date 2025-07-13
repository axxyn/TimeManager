import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:time_manager/future_handler.dart';
import 'package:time_manager/models/user.dart';
import 'package:time_manager/repositories/user_repository.dart';
import 'package:time_manager/screens/forms/user_form.dart';
import 'package:time_manager/snackbar.dart';

class UsersScreen extends HookConsumerWidget {
  UsersScreen({super.key});

  final nameController = useTextEditingController();
  final surnameController = useTextEditingController();
  final editUserId = useState<int?>(null);

  final isExpanded = useState(false);

  final _formKey = GlobalKey<FormState>();

  void clearForm() {
    nameController.clear();
    surnameController.clear();
    editUserId.value = null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);

    final future = useState(Future(() async {
      final repository = ref.read(userRepositoryProvider);
      final result = await repository.queryAll();
      return result;
    }));

    return Column(
      spacing: 8,
      children: [
        Text('Współpracownicy'),
        Expanded(
          child: FutureHandler(
            future: future.value,
            child: () {
              return ListView.builder(
                itemCount: users.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Dismissible(
                    key: Key('user${user.id}'),
                    onDismissed: (direction) async {
                      await ref.read(userRepositoryProvider).delete(user);
                      clearForm();
                    },
                    child: Card(
                      margin: EdgeInsetsGeometry.zero,
                      color: Colors.transparent,
                      child: ListTile(
                        onTap: () {
                          nameController.text = user.name;
                          surnameController.text = user.surname ?? '';
                          editUserId.value = user.id;
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(user.fullName),
                            Opacity(
                              opacity: 0.5,
                              child: Text('Id: ${user.id}'),
                            ),
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
                visible: editUserId.value != null,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    spacing: 8,
                    children: [
                      Text('Edycja: ${editUserId.value}'),
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
                child: UserForm(
                  nameController: nameController,
                  surnameController: surnameController,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      User user = User(
                        name: nameController.text,
                        surname: surnameController.text,
                      );
                      if (editUserId.value != null) {
                        user = user.copyWith(id: editUserId.value);
                      }

                      if (editUserId.value == null) {
                        try {
                          await ref.read(userRepositoryProvider).insert(user);
                        } on DatabaseException catch (error) {
                          if (error.isUniqueConstraintError()) {
                            SnackBarController.showSnackBar(
                              text: 'Użytkownik już istnieje',
                              color: SnackBarColors.error.color,
                            );
                          }
                        }
                      } else {
                        await ref.read(userRepositoryProvider).update(user);
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

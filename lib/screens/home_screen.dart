import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:time_manager/future_handler.dart';
import 'package:time_manager/init_future.dart';
import 'package:time_manager/repositories/entry_repository.dart';
import 'package:time_manager/repositories/task_repository.dart';
import 'package:time_manager/repositories/user_repository.dart';
import 'package:time_manager/screens/forms/entry_form.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(entriesProvider);

    final future = useInitFuture(() => ref.read(entryFutureProvider));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: EntryForm(),
        ),
        Expanded(
          child: FutureHandler(
            future: future,
            child: () {
              return ListView.builder(
                itemCount: entries.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  final timestamp = DateFormat.yMMMMd().add_jm().format(
                    entry.timestampDateTime,
                  );

                  final user = ref.read(userProvider(entry.coworker));
                  final task = ref.read(taskProvider(entry.task));

                  return Dismissible(
                    key: Key('entry${entry.id!.toString()}'),
                    onDismissed: (direction) async {
                      await ref.read(entryRepositoryProvider).delete(entry);
                    },
                    child: Card(
                      margin: EdgeInsetsGeometry.zero,
                      color: Colors.transparent,
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(timestamp.toString()),
                            Text(entry.id.toString()),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Zadanie: ${user.fullName}'),
                            Text('Pracownik: ${task.name}'),
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
      ],
    );
  }
}

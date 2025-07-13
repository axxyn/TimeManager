import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:time_manager/future_handler.dart';
import 'package:time_manager/models/entry.dart';
import 'package:time_manager/models/task.dart';
import 'package:time_manager/models/user.dart';
import 'package:time_manager/repositories/entry_repository.dart';
import 'package:time_manager/repositories/task_repository.dart';
import 'package:time_manager/repositories/user_repository.dart';
import 'package:time_manager/screens/forms/entry_form.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(entriesProvider);

    final future = useState(Future(() async {
      final repository = ref.read(entryRepositoryProvider);
      final result = await repository.queryAll();
      final usersId = result.map((e) => e.coworker).toList();
      final userRepository = ref.read(userRepositoryProvider);
      await userRepository.queryIds(usersId);

      final tasksId = result.map((e) => e.task).toList();
      final taskRepository = ref.read(taskRepositoryProvider);
      await taskRepository.queryIds(tasksId);
      return result;
    }));

    Widget getListTile({
      required bool isExpandable,
      required Entry entry,
      required Task task,
      required User user,
    }) {
      final timeFormat = DateFormat.jm();

      final title = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Czas: ${timeFormat.format(entry.timestampDateTime)}'),
          Opacity(opacity: 0.5, child: Text('Id: ${entry.id}')),
        ],
      );
      final subtitle = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Zadanie: ${user.fullName}'),
          Text('Pracownik: ${task.name}'),
        ],
      );

      if (isExpandable) {
        return ExpansionTile(
          title: title,
          subtitle: subtitle,
          shape: LinearBorder.none,
          collapsedShape: LinearBorder.none,
          expandedAlignment: Alignment.centerLeft,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            //TaskPage(task: task),
            if (entry.note != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text('Notatka:'), Text(entry.note!)],
              ),
          ],
        );
      } else {
        return ListTile(title: title, subtitle: subtitle);
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: EntryForm(),
        ),
        Expanded(
          child: FutureHandler(
            future: future.value,
            child: () {
              final dayFormat = DateFormat.yMMMMd();

              Map<String, List<Entry>> grouped = {};
              for (Entry entry in entries) {
                String key = dayFormat.format(entry.timestampDateTime);
                if (grouped.containsKey(key)) {
                  grouped[key]?.add(entry);
                } else {
                  grouped[key] = [entry];
                }
              }
              final groupedKeys = grouped.keys.toList();

              return ListView.builder(
                itemCount: groupedKeys.length,
                shrinkWrap: true,
                itemBuilder: (context, keyIndex) => Column(
                  children: [
                    Text(groupedKeys[keyIndex]),
                    ListView.builder(
                      itemCount: grouped[groupedKeys[keyIndex]]?.length,
                      shrinkWrap: true,
                      itemBuilder: (context, listIndex) {
                        final entry = grouped.values.elementAt(
                          keyIndex,
                        )[listIndex];

                        final user = ref.read(userProvider(entry.coworker));
                        final task = ref.read(taskProvider(entry.task));

                        return Dismissible(
                          key: Key('entry${entry.id!.toString()}'),
                          onDismissed: (direction) async {
                            await ref
                                .read(entryRepositoryProvider)
                                .delete(entry);
                          },
                          child: Card(
                            margin: EdgeInsetsGeometry.zero,
                            color: Colors.transparent,
                            child: getListTile(
                              isExpandable: entry.note != null,
                              entry: entry,
                              task: task,
                              user: user,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

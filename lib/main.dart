import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/futureHandler.dart';
import 'package:time_manager/models/task.dart';
import 'package:time_manager/repositories/taskRepository.dart';
import 'package:time_manager/database.dart';
import 'package:time_manager/repositories/userRepository.dart';
import 'package:time_manager/theme/appTheme.dart';

import 'models/user.dart';

// CTRL+W
// CTRL+ALT+L

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDb();

  runApp(ProviderScope(child: AppTheme(child: MyApp())));
}

final menuIndexProvider = StateProvider((ref) => 0);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter',
      theme: Theme.of(context),
      home: Home(),
    );
  }
}

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuIndex = ref.watch(menuIndexProvider);

    final tasksFuture = TaskRepository().queryAll();
    final usersFuture = UserRepository().queryAll();

    return Scaffold(
      body: SafeArea(
        child: <Widget>[
          Center(child: Text('Home', style: TextStyle(fontSize: 40))),
          Column(
            children: [
              Text('Zadania'),
              FutureHandler(
                future: tasksFuture,
                callback: (data) {
                  return ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      Task task = Task.fromJson(data[index]);
                      return ListTile(
                        title: Text('${task.name} ${task.duration}'),
                      );
                    },
                  );
                },
              ),
              ElevatedButton(onPressed: () {}, child: Text('Dodaj zadanie')),
            ],
          ),
          FutureHandler(
            future: usersFuture,
            callback: (data) {
              List<Widget> list = [];
              for (Map<String, dynamic> item in data) {
                User user = User.fromJson(item);
                list.add(
                  ListTile(title: Text('${user.name} ${user.surname ?? ''}')),
                );
              }
              return ExpansionTile(title: Text('Pracownicy'), children: list);
            },
          ),
        ][menuIndex],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          ref.read(menuIndexProvider.notifier).state = index;
        },
        selectedIndex: menuIndex,
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(
            icon: Badge(isLabelVisible: false, child: Icon(Icons.assignment)),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Badge(isLabelVisible: false, child: Icon(Icons.person)),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}

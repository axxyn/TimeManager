import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/models/task.dart';
import 'package:time_manager/repositories/taskRepository.dart';
import 'package:time_manager/repositories/userRepository.dart';

import 'database.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDb();

  runApp(const ProviderScope(
    child: MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<User> _users = [];
  List<Task> _tasks = [];
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();

    Future.wait([
      _fetchUsers(),
      _fetchTasks()
    ]);
  }

  Future<void> _fetchUsers() async {
    UserRepository userRepository = UserRepository();
    final userMaps = await userRepository.queryAll();
    setState(() {
      _users = userMaps.map((userMap) => User.fromJson(userMap)).toList();
    });
  }

  Future<void> _fetchTasks() async {
    TaskRepository taskRepository = TaskRepository();
    final taskMaps = await taskRepository.queryAll();
    setState(() {
      _tasks = taskMaps.map((taskMap) => Task.fromJson(taskMap)).toList();
    });
  }

  Widget wrapSafeArea(Widget child) {
    return SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: 16),
      child: child
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        wrapSafeArea(Text('Home')),
        ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${_tasks[index].name} ${_tasks[index].duration}'),
            );
          },
        ),
        ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${_users[index].name} ${_users[index].surname}'),
            );
          },
        ),
      ][currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
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

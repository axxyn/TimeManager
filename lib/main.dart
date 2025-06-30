import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:time_manager/database.dart';
import 'package:time_manager/screens/home_screen.dart';
import 'package:time_manager/screens/tasks_screen.dart';
import 'package:time_manager/screens/user_screen.dart';
import 'package:time_manager/theme/app_theme.dart';

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

    return Scaffold(
      body: SafeArea(
        child: <Widget>[
          HomeScreen(),
          TasksScreen(),
          UserScreen(),
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

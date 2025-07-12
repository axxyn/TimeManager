import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:time_manager/database.dart';
import 'package:time_manager/screens/home_screen.dart';
import 'package:time_manager/screens/settings_screen.dart';
import 'package:time_manager/screens/tasks_screen.dart';
import 'package:time_manager/screens/users_screen.dart';
import 'package:time_manager/snackbar.dart';
import 'package:time_manager/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDb();
  Intl.defaultLocale = 'pl-PL';
  await initializeDateFormatting('pl_PL', null);

  runApp(ProviderScope(child: AppTheme(child: MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      locale: Locale('pl', 'PL'),
      scaffoldMessengerKey: SnackBarController.scaffoldMessengerKey,
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
    final menuIndex = useState(1);

    return Scaffold(
      body: SafeArea(
        child: <Widget>[
          HomeScreen(),
          TasksScreen(),
          UsersScreen(),
          SettingsScreen(),
        ][menuIndex.value],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          menuIndex.value = index;
        },
        selectedIndex: menuIndex.value,
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
          NavigationDestination(
            icon: Badge(isLabelVisible: false, child: Icon(Icons.settings)),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

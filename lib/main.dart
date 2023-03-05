import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:settings_ui/settings_ui.dart';

import 'Settings/mainSettings.dart';
import 'provider/mainProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final themeProvider = ThemeProvider(prefs);

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, state) {
        return MaterialApp(
          themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: provider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          routes: {
            '/Settings': (context) => SettingsPage(),
          },
          debugShowCheckedModeBanner: false,
          home: HomeWidget(),
        );
      },
    );
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AppBar'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/Settings');
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Text('Center'),
      ),
    );
  }
}

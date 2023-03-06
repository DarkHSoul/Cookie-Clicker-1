import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Settings/mainSettings.dart';
import 'provider/mainProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final themeProvider = ThemeProvider(prefs);
  final cookieProvider = await CookieProvider
      .create(); // call create method to initialize the provider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => themeProvider),
        ChangeNotifierProvider.value(
            value:
                cookieProvider), // use value constructor to pass in the initialized provider
      ],
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

class HomeWidget extends StatefulWidget {
  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('AppBar'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Settings');
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Consumer<CookieProvider>(
                builder: (context, cookieproviding, state) {
                  return TextButton(
                    onPressed: () {
                      cookieproviding.incrementCookie();
                    },
                    child: Text('${cookieproviding.cookies}'),
                  );
                },
              ),
            ],
          ),
        ));
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testproject/upgrade/mainUpgrade.dart';
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
  int currentBottomNavigatonBarIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentBottomNavigatonBarIndex,
        onTap: (index) {
          setState(() {
            index = currentBottomNavigatonBarIndex;
          });
          currentBottomNavigatonBarIndex == 0
              ? MaterialPageRoute(builder: (context) => upgradeMain())
              : currentBottomNavigatonBarIndex == 1
                  ? MaterialPageRoute(builder: (context) => SettingsPage())
                  : null;
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_business_outlined), label: "Upgrades")
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Cookie Clicker'),
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
        child: Consumer<CookieProvider>(
          builder: (context, cookieproviding, state) {
            return Column(
              children: [
                Text(
                  "Cookies: ${cookieproviding.cookies}",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                IconButton(
                  onPressed: () {
                    cookieproviding.cookies++;
                  },
                  icon: Icon(Icons.cookie_outlined),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

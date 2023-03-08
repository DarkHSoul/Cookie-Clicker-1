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
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentBottomNavigationBarIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, state) {
        return MaterialApp(
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: provider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            routes: {
              '/Home': (context) => HomeWidget(),
              '/Settings': (context) => SettingsPage(),
              '/Upgrades': (context) => upgradeMain(),
            },
            debugShowCheckedModeBanner: false,
            home: Scaffold(
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
                        currentBottomNavigationBarIndex == 0
                            ? HomeWidget()
                            : upgradeMain(),
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
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: currentBottomNavigationBarIndex,
                onTap: (int index) {
                  setState(() {
                    currentBottomNavigationBarIndex = index;
                  });
                  switch (index) {
                    case 0:
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeWidget(),
                      ));
                      break;
                    case 1:
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => upgradeMain(),
                      ));
                      break;
                  }
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add_business_outlined),
                      label: "Upgrades")
                ],
              ),
            ));
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
    return Scaffold();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../provider/mainProvider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ThemeProvider themeProvider;

  @override
  void initState() {
    super.initState();
    themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Appearance'),
            tiles: [
              SettingsTile.switchTile(
                title: Text('Dark Mode'),
                leading: Icon(Icons.lightbulb),
                initialValue: themeProvider.isDarkMode,
                onToggle: (bool value) {
                  themeProvider.isDarkMode = value;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

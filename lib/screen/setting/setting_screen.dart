import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/local_notification_provider.dart';
import 'package:restaurant_app/provider/theme_provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final notificationProvider = context.watch<LocalNotificationProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Theme'),
            value: themeProvider.isDarkTheme,
            onChanged: (value) {
              context.read<ThemeProvider>().toggleTheme(value);
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Daily Lunch Reminder (11:00 AM)'),
            value: notificationProvider.isReminderOn,
            onChanged: (value) {
              context.read<LocalNotificationProvider>().toggleReminder(value);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _scheduleDailyTenAMNotification() async {
    // todo-03-action-01: run a schedule notification
    context.read<LocalNotificationProvider>().scheduleDailyNotification();
  }
}

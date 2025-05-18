import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/services/local_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;

  static const String _reminderPrefKey = 'isReminderOn';

  LocalNotificationProvider(this.flutterNotificationService) {
    _loadReminderStatus();
  }

  int _notificationId = 999;
  bool? _permission = false;
  bool? get permission => _permission;

  bool _isReminderOn = false;
  bool get isReminderOn => _isReminderOn;

  List<PendingNotificationRequest> pendingNotificationRequests = [];

  // Future<void> requestPermissions() async {
  //   _permission = await flutterNotificationService.requestPermissions();
  //   notifyListeners();
  // }

  Future<void> _loadReminderStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isReminderOn = prefs.getBool(_reminderPrefKey) ?? false;
    // if (_isReminderOn) {
    //   flutterNotificationService.scheduleDailyNotification(id: _notificationId);
    // }
    notifyListeners();
  }

  Future<void> toggleReminder(bool value) async {
    _isReminderOn = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reminderPrefKey, value);

    if (value) {
      // Minta permission dulu sebelum jadwalkan notifikasi
      final granted = await flutterNotificationService.requestPermissions();
      if (granted != null && granted) {
        await flutterNotificationService.scheduleDailyNotification(
          id: _notificationId,
        );
      } else {
        // Jika permission ditolak, matikan toggle dan update storage
        _isReminderOn = false;
        await prefs.setBool(_reminderPrefKey, false);
        // (Opsional) Bisa kasih feedback ke user lewat snackbar/dialog
      }
    } else {
      await flutterNotificationService.cancelNotification(_notificationId);
    }
    notifyListeners();
  }

  void showNotification() {
    _notificationId += 1;
    flutterNotificationService.showNotification(
      id: _notificationId,
      title: "New Notification",
      body: "This is a new notification with id $_notificationId",
      payload: "This is a payload from notification with id $_notificationId",
    );
  }

  void showBigPictureNotification() {
    _notificationId += 1;
    flutterNotificationService.showBigPictureNotification(
      id: _notificationId,
      title: "New Big Picture Notification",
      body: "This is a new big picture notification with id $_notificationId",
      payload:
          "This is a payload from big picture notification with id $_notificationId",
    );
  }

  void scheduleDailyNotification() {
    _notificationId += 1;
    flutterNotificationService.scheduleDailyNotification(id: _notificationId);
  }

  Future<void> checkPendingNotificationRequests(BuildContext context) async {
    pendingNotificationRequests =
        await flutterNotificationService.pendingNotificationRequests();
    notifyListeners();
  }

  Future<void> cancelNotification(int id) async {
    await flutterNotificationService.cancelNotification(id);
  }
}

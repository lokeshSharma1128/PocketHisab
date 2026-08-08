import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../http.dart';


class NotificationService {
  static final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin
  _localNotifications =
  FlutterLocalNotificationsPlugin();

  static int? _userId;

  static Future<void> init(int userId) async {
    _userId = userId;

    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings =
    DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(settings);

    await _requestPermissionAndRegisterToken();

    FirebaseMessaging.onMessage.listen(
          (RemoteMessage message) {
        final notification = message.notification;

        if (notification != null) {
          showNotification(
            title: notification.title ?? '',
            body: notification.body ?? '',
          );
        }
      },
    );

    _messaging.onTokenRefresh.listen(
          (newToken) async {
        print("FCM TOKEN REFRESHED");
        print(newToken);

        if (_userId != null) {
          await registerDeviceToken(
            newToken,
            _userId!,
          );
        }
      },
    );
  }

  static Future<void>
  _requestPermissionAndRegisterToken() async {
    try {
      NotificationSettings settings =
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus ==
          AuthorizationStatus.authorized ||
          settings.authorizationStatus ==
              AuthorizationStatus.provisional) {
        final token =
        await _messaging.getToken();

        print(
            "================================");
        print("FCM TOKEN:");
        print(token);
        print(
            "================================");

        if (token != null &&
            _userId != null) {
          await registerDeviceToken(
            token,
            _userId!,
          );
        }
      } else {
        print("Notification permission denied");
      }
    } catch (e) {
      print("FCM ERROR: $e");
    }
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'main_channel',
        'Main Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: jsonEncode({}),
    );
  }

  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
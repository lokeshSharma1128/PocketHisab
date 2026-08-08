import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

// Update this with your actual server URL (e.g., 'http://192.168.1.10:8000')
const String _baseUrl = 'http://192.168.29.166:8000';

Future<void> registerDeviceToken(
    String token,
    int userId,
    ) async {
  try {
    final response = await http.post(
      Uri.parse('$_baseUrl/register-device'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'token': token,
      }),
    );

    print(response.body);
  } catch (e) {
    print(e);
  }
}

// Future<void> sendNotification({
//   required String token,
//   required String title,
//   required String body,
//   Map<String, dynamic>? data,
// }) async {
//   try {
//     final response = await http.post(
//       Uri.parse('$_baseUrl/send-notification'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'token': token,
//         'title': title,
//         'body': body,
//         'data': data,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       print('Notification sent successfully via server');
//     } else {
//       print('Failed to send notification via server: ${response.body}');
//     }
//   } catch (e) {
//     print('Error sending notification via server: $e');
//   }
// }


Future<void> notifyUser({
  required int userId,
  required String title,
  required String body,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$_baseUrl/notify-user'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'title': title,
        'body': body,
      }),
    );

    print(response.body);
  } catch (e) {
    print('Notify User Error: $e');
  }
}
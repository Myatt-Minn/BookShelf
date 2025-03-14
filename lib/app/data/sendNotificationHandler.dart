import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print(message.data);
}

class SendNotificationHandler {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? serverKeyGG;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "nonglao-2e356",
      "private_key_id": "aabafe1b84e37fd14bb22261d6ad62618b0d143b",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDMOl4oLmmCi9N2\nxHjA4KkAVh4pu+G8HF9Ag6enHAuLiWW4Qb8ig7+l/r/cSPK2tZhNSnF9NNMpPUyT\n1zfWlUJXGaV48/2uiro0yU91rF0FYjyWazff0J/0EXYD2jWTQyJsYZJtK2Sw+Dbb\n3ilTzwaRnaEFQ5NoRiWY1+eiBS8u5o4X6E8B7EsKGgtjggil6mp6oeYVjJK/zQ9t\nT8vkA3TznsSE/OLKEJS9f4KSHrD7u6KBPEn+Yx29FFK2TOzSY5wYczKGJQcbHaY/\nP/ne+im8mNOjLGMoLT0V9Y4eeO9c6X1ooB4fWM49FmwMzEbptS4Pnxe897pdv0Vn\nvE2y6C0bAgMBAAECggEAShEBBOGQMmAzmOc4Q/s2T4Dr/4a8H1TK1sLokpqBNWHn\nGiP+Ba5yWulA+8sY+1pwmdddwWLfEh3BH/z1q0UGgkAy2uLiJeL6FRrNTofsVH+E\nKalI4krvN7z9Z/hDZdz7JwNb72vFYMkkXCj+I/75CuZ390jCtRZ7nCrxPrlSm1cs\nWPsEGbisR905s8p3tm7Ot+nA0KrfLIsgplr4SGjRD7x2Nm91gf0pKOoFOaycFKUX\nOmyOVlzGKkbxix+YenOIA//wNrD5FsBMM9hQOgFKkM3xUmmGgQOQ+stym5JNYovc\nSiknemll+kZzxSU2XJ7+470QVOgbpghvPVehoAcbgQKBgQDqp95TZOF0CIObTYOJ\nvM/kFGkPn5vQrH4e55x2H8UokcY1YVnEbCXip4JL4UQ9KL7jL1WhIrgfCk/9XEf4\nEoVTGOAMXm4fP5oLEqs5vVHg7mdToJSwyuPV9mwIsKSLHunxszr2mCrouwAOYN99\nZfKTD6MQpxM2IfPI3wY5GvAfowKBgQDezfeTIP9muct/1+jUjNXhk7Z1150BlhV/\nMpjliqwk/46QfJX6l56TsJ+SKNz5toowzl7adVrlznUa/qu8M84PL5Hlt69/bUrg\nfk3gw3YWHfpUqifBwsSvbzF8vJ5w8Uv83b+cgOE0T4vU4w+PgUoxgMKu6ovYcCPW\nFbEB/EI0KQKBgDfFHfoEB/Fj9KN8kL6zuVUj5LRp4sZ9uJvvwCfy9RDnVIxrTsJ4\nUajE1xrhty4x+OxV26wobEo0UT6OKCy1eip9xwIpj1Kt8xaeoUNf0436G2SszaoX\nDn9Tyelm0jSebEudpW3mTIxzpVfFflh3WmfJV6AllVNQTnh3SStZU6ixAoGADvxb\ngpHdm9MzVM344xL17843n4V5Efo+R+fnUMka+wIVXLKEg+5exCBFG1eURVd5w/6d\ncqQiEQLp7X7jniz91xekAIdyTmfTeXYFVvDOqH4rsDYhpm6rPAGGmpU1MvOH4OIp\nWSVyAEq5ZQBAs65Ghz3Z2ln8PfqM7oFW/oMxEMECgYBAniHkxP2sxPKJ6euKnfL7\ns/o040b9yEFmEC1QUfXC70g4mJ58fjVa7TPoQ5Bw9h+RTq8oWdVZyEFoEwanzc1D\nPFjG538c6TdjquebADYhCFox7+2Gi1fAX7MFA73T/PpYWqDRCw1g3lmwdyExVNcN\nx5vpxc9lfBXYv0+oqUMJgA==\n-----END PRIVATE KEY-----\n",
      "client_email": "bookshelf@nonglao-2e356.iam.gserviceaccount.com",
      "client_id": "110221454273524023949",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/bookshelf%40nonglao-2e356.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com",
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials = await auth
        .obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client,
        );

    client.close();
    return credentials.accessToken.data;
  }

  Future<void> getKey() async {
    serverKeyGG = await getAccessToken();
    print(serverKeyGG);
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    Get.toNamed('/notification');
  }

  Future initPushNotification() async {
    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
            alert: true,
            badge: true,
            sound: true,
          );

      await FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

      FirebaseMessaging.onMessage.listen((message) async {
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print(message.data);
          // Local Notification Code to Display Alert
          displayNotification(message);

          print('GG');
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    } catch (e) {
      Get.snackbar("Sorry", "Something went wrong");
    }
  }

  Future<void> initNotification() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Get the FCM token
    final fCMToken = await FirebaseMessaging.instance.getToken();

    if (fCMToken != null) {
      // Store FCM token in Supabase
      final supabase = Supabase.instance.client;

      try {
        // Get the current user's UID
        final uid = supabase.auth.currentSession?.user.id;

        if (uid == null) {
          Get.snackbar(
            'Error',
            'User is not authenticated.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        // Update the token for the existing row with matching UID
        await supabase.from('users').update({'token': fCMToken}).eq('uid', uid);
      } catch (e) {
        print('Error updating token: $e');
      }
    } else {
      print('Failed to get FCM token');
    }

    // Call to initialize push notifications (this part might still be handled via Firebase or another service)
    initPushNotification();
  }

  static void displayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "push_notification_demo",
          "push_notification_demo_channel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: json.encode(message.data),
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  static void initialized() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: initializationSettingsAndroid),
      onDidReceiveNotificationResponse: (details) {
        print(details.toString());
        print("localBackgroundHandler :");
        print(
          details.notificationResponseType ==
                  NotificationResponseType.selectedNotification
              ? "selectedNotification"
              : "selectedNotificationAction",
        );
        print(details.payload);

        try {
          json.decode(details.payload ?? "{}") as Map? ?? {};
        } catch (e) {
          print(e);
        }
      },
      onDidReceiveBackgroundNotificationResponse: localBackgroundHandler,
    );
  }

  Future<void> sendPushNotificationToAllUsers(String title, String body) async {
    try {
      // Fetch all users with a valid token from Supabase
      final response = await Supabase.instance.client
          .from('users')
          .select('token');

      List<String> tokens = [];
      final List<dynamic> users = response as List<dynamic>;

      // Collect valid tokens
      for (var user in users) {
        String? token = user['token'];
        if (token != null && token.isNotEmpty) {
          tokens.add(token);
        }
      }

      if (tokens.isEmpty) {
        Get.snackbar('GG', 'No tokens found!');
        return;
      }

      // Store the notification in Supabase (notifications table)

      await Supabase.instance.client.from('notifications').insert([
        {
          'notification_id': DateTime.now().millisecondsSinceEpoch.toString(),
          'title': title,
          'body': body,
        },
      ]);

      // Send push notifications to each token (using FCM)
      for (String token in tokens) {
        await sendPushNotification(token: token, title: title, body: body);
      }
    } catch (e) {
      print('Error sending notifications: $e');
    }
  }

  Future<void> sendPushNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    final Uri url = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/nonglao-2e356/messages:send',
    );

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKeyGG',
    };

    final Map<String, dynamic> payload = {
      'message': {
        'token': token,
        'notification': {'title': title, 'body': body},
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'message': 'This is additional data payload',
        },
      },
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Push Notification Sent Successfully!');
      } else {
        print('Failed to send push notification: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while sending push notification: $e');
    }
  }

  static Future<void> localBackgroundHandler(NotificationResponse data) async {
    print(data.toString());
    print("localBackgroundHandler :");
    print(
      data.notificationResponseType ==
              NotificationResponseType.selectedNotification
          ? "selectedNotification"
          : "selectedNotificationAction",
    );
    print(data.payload);

    try {
      json.decode(data.payload ?? "{}") as Map? ?? {};
      // openNotification(payloadObj);
    } catch (e) {
      print(e);
    }
  }
}

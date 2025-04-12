import 'dart:io';

import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x_book_shelf/app/data/MyTranslations.dart';
import 'package:x_book_shelf/app/data/consts_config.dart';
import 'package:x_book_shelf/app/data/sendNotificationHandler.dart';
import 'package:x_book_shelf/app/modules/splash/bindings/splash_binding.dart';
import 'package:x_book_shelf/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SendNotificationHandler.initialized();
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      name: "nonglao-2e356",
    );
  }
  await Supabase.initialize(
    url: "https://antcuomusxnkomvnyujf.supabase.co",
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFudGN1b211c3hua29tdm55dWpmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDEyNTg5NDgsImV4cCI6MjA1NjgzNDk0OH0.0eNMqBKxinzyiqFZ8aCnGP8L18TAi2V6-aMIPVPvNBc',
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    String? savedLanguage = GetStorage().read('language') ?? 'MYN';
    runApp(
      BetterFeedback(
        child: GetMaterialApp(
          translations: MyTranslations(),
          // Set the locale dynamically based on the saved language
          locale:
              savedLanguage == 'ENG'
                  ? const Locale('en', 'US')
                  : const Locale('my', 'MM'),
          fallbackLocale: const Locale(
            'en',
            'US',
          ), // Set a fallback language (e.g., English)
          title: ConstsConfig.appname,
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.light,
          //initialRoute: isFirstTime ? AppPages.ON_BOARDING : AppPages.MY_HOME,
          initialRoute: AppPages.INITIAL,
          initialBinding: SplashBinding(),
          getPages: AppPages.routes,
        ),
      ),
    );
  });
}

Future<void> cloneRow(
  String tableName,
  String originalRowId,
  String newRowId,
) async {
  final supabase = Supabase.instance.client;

  // Fetch the original row
  final response =
      await supabase.from(tableName).select().eq('id', originalRowId).single();

  // Remove the original ID and set a new one (if necessary)
  Map<String, dynamic> data = Map<String, dynamic>.from(response);
  data.remove('id'); // Assuming 'id' is the primary key (optional)
  data['id'] = newRowId; // Set a new ID if needed

  // Insert the cloned row
  await supabase.from(tableName).insert(data);
  print('Row cloned successfully!');
}

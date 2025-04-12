import 'dart:typed_data';

import 'package:feedback/feedback.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MoreController extends GetxController {
  //TODO: Implement MoreController

  void openUrl(String url) {}

  Future<void> uploadFeedbackToSupabase(UserFeedback feedback) async {
    final supabase = Supabase.instance.client;
    final Uint8List screenshot = feedback.screenshot;
    final String text = feedback.text;

    // Generate a unique file name using timestamp
    String fileName = 'feedback_${DateTime.now().millisecondsSinceEpoch}.png';

    try {
      // Upload the screenshot to Supabase Storage
      final response = await supabase.storage
          .from('feedback_screenshots')
          .uploadBinary(
            fileName,
            screenshot,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // Get the public URL of the uploaded file
      final imageUrl = supabase.storage
          .from('feedback_screenshots')
          .getPublicUrl(fileName);

      // Save feedback details in Supabase Database
      await supabase.from('feedbacks').insert({
        'text': text,
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
      });

      print("Feedback uploaded successfully!");
    } catch (error) {
      print("Error uploading feedback: $error");
    }
  }
}

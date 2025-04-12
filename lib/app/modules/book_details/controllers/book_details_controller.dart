import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x_book_shelf/app/data/BookModel.dart';
import 'package:x_book_shelf/app/modules/downloads/views/pdfViewPage.dart';

class BookDetailsController extends GetxController {
  //TODO: Implement BookDetailsController

  final box = GetStorage();
  var recommendedBooks = <BookModel>[].obs;
  BookModel book = Get.arguments;
  @override
  void onInit() {
    super.onInit();
    fetchRecommendedBooks(book.category);
  }

  Future<void> fetchRecommendedBooks(String category) async {
    try {
      final response = await Supabase.instance.client
          .from('books')
          .select()
          .eq('category', category) // Filter by category
          .limit(10); // Limit to 10 books

      // Assuming your data is returned as a list
      recommendedBooks.value =
          (response as List)
              .map((item) => BookModel.fromMap(item as Map<String, dynamic>))
              .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch books');
    }
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) {
        return true;
      }
      if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      }
      return false;
    }
    return true; // iOS doesn't require manual permission requests
  }

  Future<void> downloadBook(BookModel book) async {
    try {
      bool hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        Get.snackbar(
          "Permission Request",
          "Storage permission is required to download files.",
          backgroundColor: Colors.yellow,
        );
        return;
      }

      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      String filePath =
          '${directory.path}/${book.title.replaceAll(' ', '_')}.pdf';

      Dio dio = Dio();

      // Observable variable to track progress
      var progress = 0.0.obs;

      // Show download progress dialog
      Get.dialog(
        Obx(
          () => AlertDialog(
            title: Text("Downloading..."),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: progress.value),
                SizedBox(height: 10),
                Text("${(progress.value * 100).toStringAsFixed(0)}%"),
              ],
            ),
          ),
        ),
        barrierDismissible: false, // Prevent user from closing the dialog
      );

      // Start Download with progress tracking
      await dio.download(
        book.pdfUrl,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            progress.value = received / total;
          }
        },
      );

      Get.back(); // Close dialog after download completion

      // Save downloaded book info
      List<Map<String, dynamic>> downloadedBooks =
          (box.read<List>('downloaded_books') ?? [])
              .map((e) => e as Map<String, dynamic>)
              .toList();
      downloadedBooks.add({
        'title': book.title,
        'path': filePath,
        'author': book.author,
        'coverUrl': book.coverUrl,
        'category': book.category,
        'page': book.page,
        'rating': book.rating,
      });
      box.write('downloaded_books', downloadedBooks);

      Get.snackbar(
        "Success",
        "Download Complete",
        backgroundColor: Colors.green,
      );
      File file = File(filePath);
      if (file.existsSync()) {
        Get.to(() => PdfViewPage(), arguments: book);
      } else {
        Get.snackbar("Error", "File not found. Please download it again.");
      }
    } catch (e) {
      Get.back(); // Close the dialog in case of an error
      Get.snackbar("Error", "Download Failed: $e", backgroundColor: Colors.red);
    }
  }

  void saveToFav() {
    // Save downloaded book info
    List<BookModel> favouriteBooks =
        (box.read<List>('fav_books') ?? []).map((e) => e as BookModel).toList();
    favouriteBooks.add(book);
    box.write('fav_books', favouriteBooks);
    Get.snackbar(
      "Success",
      "Book Added to Favourites",
      backgroundColor: Colors.green,
    );
  }

  void shareBook(BookModel book) {
    final text = '${book.title} by ${book.author}\nDownload: ${book.pdfUrl}';
    Share.share(text);
  }
}

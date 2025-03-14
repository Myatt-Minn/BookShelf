import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_book_shelf/app/data/BookModel.dart';
import 'package:x_book_shelf/app/modules/downloads/views/pdfViewPage.dart';

import '../controllers/downloads_controller.dart';

class DownloadsView extends GetView<DownloadsController> {
  const DownloadsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Downloaded Books")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Obx(
          () =>
              controller.downloadedBooks.isEmpty
                  ? const Center(child: Text("No books downloaded"))
                  : ListView.builder(
                    itemCount: controller.downloadedBooks.length,
                    itemBuilder: (context, index) {
                      final bookData = controller.downloadedBooks[index];

                      // Convert the saved data into BookModel
                      final book = BookModel(
                        title: bookData['title'] ?? 'Unknown Title',
                        author: bookData['author'] ?? 'Unknown Author',
                        coverUrl: bookData['coverUrl'] ?? '',
                        category: bookData['category'] ?? 'Unknown Category',
                        page: bookData['page'] ?? '',
                        pdfUrl: bookData['path'] ?? '',
                        rating: bookData['rating'] ?? 4.9,
                      );

                      return buildbookListItem(book, index);
                    },
                  ),
        ),
      ),
    );
  }

  Widget buildbookListItem(BookModel book, int index) {
    return InkWell(
      onTap: () {
        File file = File(book.pdfUrl);
        if (file.existsSync()) {
          Get.to(() => PdfViewPage(), arguments: book);
        } else {
          Get.snackbar("Error", "File not found. Please download it again.");
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: FancyShimmerImage(
                  imageUrl:
                      book.coverUrl.isNotEmpty
                          ? book.coverUrl
                          : 'https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg',
                  height: 100,
                  width: 100,
                  boxFit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        book.category,
                        style: const TextStyle(color: Colors.blue),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          Text(
                            book.rating.toString(),
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    controller.removeBook(index);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  child: const Icon(
                    Icons.delete,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

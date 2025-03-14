import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:x_book_shelf/app/data/BookModel.dart';
import 'package:x_book_shelf/app/modules/downloads/controllers/downloads_controller.dart';

class PdfViewPage extends GetView<DownloadsController> {
  const PdfViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    BookModel pdf = Get.arguments;
    return Scaffold(
      appBar: AppBar(title: Text(pdf.title)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/book-comments', arguments: pdf);
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.comment),
      ),
      body: SfPdfViewer.file(
        File(pdf.pdfUrl),
        key: GlobalKey<SfPdfViewerState>(),
        pageLayoutMode: PdfPageLayoutMode.single, // Show full-page slides
        scrollDirection: PdfScrollDirection.horizontal, // Swipe left/right
        canShowScrollHead: false, // Hide scrollbar
        canShowPaginationDialog: false, // Hide jump-to-page dialog
      ),
    );
  }
}

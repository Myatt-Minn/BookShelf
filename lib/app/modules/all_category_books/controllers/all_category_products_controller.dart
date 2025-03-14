import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x_book_shelf/app/data/BookModel.dart';

class AllCategoryBooksController extends GetxController {
  //TODO: Implement AllCategorybooksController

  RxList<BookModel> books = <BookModel>[].obs; // List of all books
  RxList<BookModel> filteredbooks =
      <BookModel>[].obs; // Filtered list based on search
  RxString searchQuery = ''.obs;
  RxBool isLoading = false.obs;
  RxString? categorygg = ''.obs;
  @override
  void onInit() {
    super.onInit();
    categorygg!.value = Get.arguments;
    fetchbooks(category: categorygg!.value);
  }

  Future<void> fetchbooks({required String category}) async {
    try {
      isLoading.value = true;

      // Query Supabase to get books based on the 'category' field
      final response = await Supabase.instance.client
          .from('books')
          .select('*')
          .eq('category', category);

      // Map Supabase data to the book model
      books.value =
          (response as List<dynamic>).map((data) {
            return BookModel.fromMap(data as Map<String, dynamic>);
          }).toList();

      // Update the filteredbooks list
      filteredbooks.assignAll(books);
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');

      // Display error in the UI
      Get.snackbar(
        'Error',
        'Failed to fetch books',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void searchbooks(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredbooks.assignAll(books);
    } else {
      filteredbooks.assignAll(
        books
            .where(
              (book) => book.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }
}

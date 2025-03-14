import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x_book_shelf/app/data/BookModel.dart';
import 'package:x_book_shelf/app/data/category_model.dart';

class HomeController extends GetxController {
  RxList<BookModel> bookList = <BookModel>[].obs;
  RxList<BookModel> popularbooks = <BookModel>[].obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  late PageController pageController;
  var noticount = 0.obs;
  // List to store banner URLs
  var banners = <String>[].obs;

  var currentBanner = 0.obs;
  var isLoading = true.obs;

  @override
  void onInit() async {
    super.onInit();

    fetchBanners();
    pageController = PageController(initialPage: currentBanner.value);
    startAutoSlide();
    await fetchbooks();
    await fetchPopular();
    fetchCategories();
    // Fetch and count Notifications
    final notis = await Supabase.instance.client
        .from('notifications')
        .select('id');
    noticount.value = notis.length;
    isLoading.value = false;
  }

  // Fetch categories from Firestore
  Future<void> fetchCategories() async {
    try {
      final response =
          await Supabase.instance.client
              .from('categories') // Replace with your table name
              .select();

      // Assuming your data is returned in 'data' field
      categories.value =
          (response as List)
              .map(
                (item) => CategoryModel.fromJson(item as Map<String, dynamic>),
              )
              .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories');
    }
  }

  Future<void> fetchbooks() async {
    try {
      final response =
          await Supabase.instance.client
              .from('books') // Replace with your table name
              .select();

      bookList.value =
          (response as List).map((item) {
            // Ensure that the data is in the correct format
            return BookModel.fromMap(item as Map<String, dynamic>);
          }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch books $e');
    }
  }

  Future<void> fetchPopular() async {
    try {
      final response = await Supabase.instance.client
          .from('books') // Replace with your table name
          .select()
          .eq('popular', true) // Filter for popular books
          ;

      popularbooks.value =
          (response as List).map((item) {
            return BookModel.fromMap(item as Map<String, dynamic>);
          }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch popular books');
    }
  }

  // Function to change the current page
  void changePage(int value) {
    currentBanner.value = value;
  }

  Future<void> fetchBanners() async {
    try {
      final response = await Supabase.instance.client
          .from('banners') // Replace with your table name
          .select('imgUrl') // Only fetch the imgUrl column
          ;

      banners.value =
          (response as List).map((item) => item['imgUrl'].toString()).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load banners');
    }
  }

  void startAutoSlide() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentBanner.value < banners.length - 1) {
        currentBanner.value++;
      } else {
        currentBanner.value = 0; // Loop back to the first banner
      }

      pageController.animateToPage(
        currentBanner.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }
}

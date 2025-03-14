import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x_book_shelf/app/data/category_model.dart';

class CategoriesController extends GetxController {
  var isLoading = false.obs;
  var categories = <CategoryModel>[].obs;
  var filterCategories = <CategoryModel>[].obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  final SupabaseClient supabase = Supabase.instance.client;

  // Fetch categories from Supabase
  Future<void> fetchCategories() async {
    isLoading.value = true;
    try {
      final response = await supabase.from('categories').select();

      categories.value =
          (response as List).map((item) {
            return CategoryModel.fromJson(item);
          }).toList();
      filterCategories.assignAll(categories);
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories');
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filterCategories.assignAll(categories);
    } else {
      filterCategories.assignAll(
        categories
            .where(
              (product) =>
                  product.title.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }
}

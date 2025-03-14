import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x_book_shelf/app/data/AuthorModel.dart';

class AuthorController extends GetxController {
  //TODO: Implement AuthorController
  var selectedauthor = 'author'.obs; // Observable for author selection
  var isLoading = false.obs;
  var authors = <AuthorModel>[].obs;
  var filterauthors = <AuthorModel>[].obs;
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchauthors();
  }

  final SupabaseClient supabase = Supabase.instance.client;

  // Fetch authors from Supabase
  Future<void> fetchauthors() async {
    isLoading.value = true;
    try {
      final response = await supabase.from('authors').select();

      authors.value =
          (response as List).map((item) {
            return AuthorModel.fromMap(item);
          }).toList();
      filterauthors.assignAll(authors);
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch authors $e');
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filterauthors.assignAll(authors);
    } else {
      filterauthors.assignAll(
        authors
            .where(
              (product) =>
                  product.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList(),
      );
    }
  }
}

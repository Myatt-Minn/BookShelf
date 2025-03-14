import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x_book_shelf/app/data/AuthorModel.dart';
import 'package:x_book_shelf/app/data/BookModel.dart';

class AuthorProfileController extends GetxController {
  //TODO: Implement InstructorProfileController

  var books = <BookModel>[].obs;
  AuthorModel instructor = Get.arguments;

  var profileImg = ''.obs;
  var username = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchbooks(instructor.booksWritten);
  }

  Future<void> fetchbooks(List<String> courseIds) async {
    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('books')
          .select()
          .filter('id', 'in', courseIds);

      books.value =
          response.map<BookModel>((video) => BookModel.fromMap(video)).toList();
    } catch (e) {
      print(e);
    }
  }
}

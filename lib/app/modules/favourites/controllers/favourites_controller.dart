import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:x_book_shelf/app/data/BookModel.dart';

class FavouritesController extends GetxController {
  //TODO: Implement FavouritesController
  final box = GetStorage();

  var favBooks = <BookModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    favBooks.value =
        (box.read<List>('fav_books') ?? []).map((e) => e as BookModel).toList();
  }
}

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DownloadsController extends GetxController {
  //TODO: Implement DownloadsController

  final box = GetStorage();

  var downloadedBooks = [].obs;
  @override
  void onInit() {
    super.onInit();
    downloadedBooks.value =
        (box.read<List>('downloaded_books') ?? [])
            .map((e) => e as Map<String, dynamic>)
            .toList();
  }

  void removeBook(int index) {
    downloadedBooks.removeAt(index);
    box.write('downloaded_books', downloadedBooks);
  }
}

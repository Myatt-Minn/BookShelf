import 'package:get/get.dart';

import '../controllers/category_controller.dart';

class CategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CategoriesController());
  }
}

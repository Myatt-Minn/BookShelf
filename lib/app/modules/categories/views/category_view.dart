import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_book_shelf/app/modules/categories/controllers/category_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.category),
        title: Text(
          'categories'.tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 15),
            Expanded(child: _buildCategoryGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) {
        controller.searchProducts(value);
      },
      decoration: InputDecoration(
        filled: true,
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        hintText: 'search'.tr,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Obx(
      () =>
          controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Adjust for desired columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8, // Adjust for icon and text proportion
                ),
                itemCount: controller.filterCategories.length,
                itemBuilder: (context, index) {
                  final category = controller.filterCategories[index];
                  return _buildCategoryIcon(category.imgUrl, category.title);
                },
              ),
    );
  }

  Widget _buildCategoryIcon(String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/all-category-books', arguments: label);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 35, backgroundImage: NetworkImage(imagePath)),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:x_book_shelf/app/data/BookModel.dart';
import 'package:x_book_shelf/app/data/consts_config.dart';
import 'package:x_book_shelf/app/modules/categories/controllers/category_controller.dart';
import 'package:x_book_shelf/app/modules/navigation_screen/controllers/navigation_screen_controller.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // App bar with logo and notification icon
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 15.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            ConstsConfig.logo, // Add your app logo here
                            height: 50,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "BookShelf App",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ConstsConfig.appname,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Obx(
                      () => Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications),
                            onPressed: () {
                              Get.toNamed('/notifications');
                            },
                          ),
                          if (controller.noticount.value >
                              0) // Show badge only if there are items
                            Positioned(
                              right: 8,
                              top: 8,
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed('/notifications');
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '${controller.noticount.value}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed('/all-books');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Same fill color
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Rounded corners
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: Colors.black,
                        ), // Search Icon
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'search'.tr,
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                            ), // Hint text styling
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list),
                          onPressed: () {
                            Get.toNamed('/all-books');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Dots Indicator
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller
                        .banners
                        .length, // Generate dots based on the number of banners
                    (index) => buildDot(index, controller.currentBanner.value),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              // Category Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "categories".tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.find<NavigationScreenController>()
                            .currentIndex
                            .value = 1;
                        Get.put(CategoriesController());
                      },
                      child: Text(
                        "${'see_all'.tr} >",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Adjusted Category ListView with Proper Height
              // Horizontal list of circular category icons
              _buildCategoryIcons(),

              const SizedBox(height: 10),
              // Popular Shoes Section
              buildSectionHeader("pop_pro".tr, () {
                Get.toNamed('/all-popular-books');
              }),
              const SizedBox(height: 10),
              Obx(() {
                return controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                      height: 240, // Height for the horizontal list
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            controller
                                .popularbooks
                                .length, // Replace with actual data length
                        itemBuilder: (context, index) {
                          return buildbookCard(controller.popularbooks[index]);
                        },
                      ),
                    );
              }),

              const SizedBox(height: 20),

              // New Arrivals Section
              buildSectionHeader("new_arri".tr, () {
                Get.toNamed('/all-books');
              }),
              Obx(() {
                return controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          controller
                              .bookList
                              .length, // Replace with actual data length
                      itemBuilder: (context, index) {
                        return buildBookListItem(controller.bookList[index]);
                      },
                    );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Build the section header with "See all"
  Widget buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: Row(
              children: [
                Text("see_all".tr, style: TextStyle(color: Colors.blue)),
                Icon(Icons.arrow_forward_ios, size: 12, color: Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildbookCard(BookModel book) {
    return InkWell(
      onTap: () {
        Get.toNamed('/book-details', arguments: book);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wrap the image in ClipRRect to apply border radius
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: FancyShimmerImage(
                  imageUrl:
                      book.coverUrl.isNotEmpty
                          ? book.coverUrl
                          : 'https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg',
                  height: 150,
                  width: double.infinity,
                  boxFit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      book.category,
                      style: const TextStyle(color: Colors.blue),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow),
                        Text(
                          book.rating.toString(),
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build vertical book item for "New Arrivals"
  Widget buildBookListItem(BookModel book) {
    return InkWell(
      onTap: () {
        Get.toNamed('/book-details', arguments: book);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8), // Apply rounded corners
                child: FancyShimmerImage(
                  imageUrl:
                      book.coverUrl.isNotEmpty
                          ? book.coverUrl
                          : 'https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg',
                  height: 100,
                  width: 80,
                  boxFit: BoxFit.fill,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        book.category,
                        style: const TextStyle(color: Colors.blue),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.yellow),
                          Text(
                            book.rating.toString(),
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/book-details', arguments: book);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    shape: const CircleBorder(),
                    backgroundColor: ConstsConfig.primarycolor,
                  ),
                  child: const Icon(
                    Icons.download,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Category Icon Widget
  Widget _categoryIcon(String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/all-category-books', arguments: label);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            CircleAvatar(radius: 35, backgroundImage: NetworkImage(imagePath)),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcons() {
    return SizedBox(
      height: 110, // Height for the circular icons list
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            return _categoryIcon(category.imgUrl, category.title);
          },
        ),
      ),
    );
  }

  // Dot builder for the page indicator
  Widget buildDot(int index, int currentPage) {
    return Container(
      height: 10.0,
      width: currentPage == index ? 18 : 7,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.black38,
      ),
    );
  }
}

import 'package:get/get.dart';

import '../modules/all_books/bindings/all_books_binding.dart';
import '../modules/all_books/views/all_books_view.dart';
import '../modules/all_category_books/bindings/all_category_products_binding.dart';
import '../modules/all_category_books/views/all_category_products_view.dart';
import '../modules/all_popular_books/bindings/all_popular_books_binding.dart';
import '../modules/all_popular_books/views/all_popular_books_view.dart';
import '../modules/author/bindings/author_binding.dart';
import '../modules/author/views/author_view.dart';
import '../modules/author_profile/bindings/instructor_profile_binding.dart';
import '../modules/author_profile/views/instructor_profile_view.dart';
import '../modules/book_details/bindings/book_details_binding.dart';
import '../modules/book_details/views/book_details_view.dart';
import '../modules/categories/bindings/category_binding.dart';
import '../modules/categories/views/category_view.dart';
import '../modules/downloads/bindings/downloads_binding.dart';
import '../modules/downloads/views/downloads_view.dart';
import '../modules/favourites/bindings/favourites_binding.dart';
import '../modules/favourites/views/favourites_view.dart';
import '../modules/gate/bindings/gate_binding.dart';
import '../modules/gate/views/gate_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/more/bindings/more_binding.dart';
import '../modules/more/views/more_view.dart';
import '../modules/navigation_screen/bindings/navigation_screen_binding.dart';
import '../modules/navigation_screen/views/navigation_screen_view.dart';
import '../modules/no_internet/bindings/no_internet_binding.dart';
import '../modules/no_internet/views/no_internet_view.dart';
import '../modules/notifications/bindings/notification_binding.dart';
import '../modules/notifications/views/notification_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.NAVIGATION_SCREEN,
      page: () => NavigationScreenView(),
      binding: NavigationScreenBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.FAVOURITES,
      page: () => const FavouritesView(),
      binding: FavouritesBinding(),
    ),
    GetPage(
      name: _Paths.DOWNLOADS,
      page: () => const DownloadsView(),
      binding: DownloadsBinding(),
    ),
    GetPage(
      name: _Paths.MORE,
      page: () => const MoreView(),
      binding: MoreBinding(),
    ),
    GetPage(
      name: _Paths.AUTHOR,
      page: () => const AuthorView(),
      binding: AuthorBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.CATEGORIES,
      page: () => const CategoriesView(),
      binding: CategoriesBinding(),
    ),
    GetPage(
      name: _Paths.BOOK_DETAILS,
      page: () => const BookDetailsView(),
      binding: BookDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ALL_CATEGORY_BOOKS,
      page: () => const AllCategoryBooksView(),
      binding: AllCategoryBooksBinding(),
    ),
    GetPage(
      name: _Paths.AUTHOR_PROFILE,
      page: () => const AuthorProfileView(),
      binding: AuthorProfileBinding(),
    ),
    GetPage(
      name: _Paths.NO_INTERNET,
      page: () => const NoInternetView(),
      binding: NoInternetBinding(),
    ),
    GetPage(
      name: _Paths.GATE,
      page: () => const GateView(),
      binding: GateBinding(),
    ),
    GetPage(
      name: _Paths.ALL_BOOKS,
      page: () => const AllBooksView(),
      binding: AllBooksBinding(),
    ),
    GetPage(
      name: _Paths.ALL_POPULAR_BOOKS,
      page: () => const AllPopularBooksView(),
      binding: AllPopularBooksBinding(),
    ),
  ];
}

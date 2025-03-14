import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:x_book_shelf/app/data/notification_model.dart';

class NotificationController extends GetxController {
  RxList<NotificationModel> notifications = RxList<NotificationModel>();

  @override
  void onInit() async {
    super.onInit();
    await fetchNotifications();
  }

  // Fetch all notifications from Supabase
  Future<void> fetchNotifications() async {
    try {
      // Query Supabase to get orders, ordered by 'orderDate' in descending order
      final response = await Supabase.instance.client
          .from('notifications') // 'orders' is the table in Supabase
          .select() // Select all columns
          .order(
            'created_at',
            ascending: false,
          ) // Order by 'orderDate' descending
          ;
      // Map Supabase response data to OrderItem model
      notifications.value = List<NotificationModel>.from(
        response.map((order) => NotificationModel.fromMap(order)),
      );
    } catch (e) {
      print(e);
    }
  }
}

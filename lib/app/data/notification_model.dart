class NotificationModel {
  final int id;
  final String title;
  final String body;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> doc) {
    return NotificationModel(
      id: doc['id'],
      title: doc['title'],
      body: doc['body'],
    );
  }
}

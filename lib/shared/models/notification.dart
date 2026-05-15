class LakbayNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;

  LakbayNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  LakbayNotification copyWith({bool? isRead}) {
    return LakbayNotification(
      id: id,
      title: title,
      message: message,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

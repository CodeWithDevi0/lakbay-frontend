import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification.dart';

final notificationsProvider = NotifierProvider<NotificationsNotifier, List<LakbayNotification>>(() {
  return NotificationsNotifier();
});

class NotificationsNotifier extends Notifier<List<LakbayNotification>> {
  @override
  List<LakbayNotification> build() {
    return [
      LakbayNotification(
        id: '1',
        title: 'Trip Confirmed!',
        message: 'Your adventure to Mt. Apo has been confirmed. Get your gear ready!',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      LakbayNotification(
        id: '2',
        title: 'New Message',
        message: 'Alex added a new photo to the "Davao Del Sur" group memories.',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      LakbayNotification(
        id: '3',
        title: 'Budget Alert',
        message: 'You have spent 85% of your allocated budget for the Samal trip.',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  void markAsRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n,
    ];
  }

  void markAllAsRead() {
    state = [
      for (final n in state) n.copyWith(isRead: true),
    ];
  }

  int get unreadCount => state.where((n) => !n.isRead).length;
}

final unreadNotificationsCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).where((n) => !n.isRead).length;
});

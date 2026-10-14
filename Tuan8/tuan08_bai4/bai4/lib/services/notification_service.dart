import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static AndroidFlutterLocalNotificationsPlugin? get _androidImpl => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  Future<void> init() async {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);

    // Xin quyền thông báo (Android 13+)
    await _androidImpl?.requestNotificationsPermission();
  }

  static AndroidNotificationDetails _androidDetails(
    String id,
    String name,
    String description,
  ) {
    return AndroidNotificationDetails(
      id,
      name,
      channelDescription: description,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
  }

  // 1. Gửi thông báo tức thì
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = _androidDetails(
      'vocab_instant_channel',
      'Thông báo học từ',
      'Thông báo tức thì khi lưu từ vựng',
    );

    await _plugin.show(id, title, body, NotificationDetails(android: details));
  }

  // 2. Hẹn giờ nhắc học sau 10 phút
  Future<void> scheduleAfter10Minutes({
    required int id,
    required String word,
    required String meaning,
  }) async {
    final details = _androidDetails(
      'vocab_schedule_channel',
      'Lịch nhắc từ vựng',
      'Nhắc ôn tập từ vựng sau 10 phút',
    );

    final scheduledDate = tz.TZDateTime.now(tz.local)
        .add(const Duration(minutes: 10));

    final canExact =
        await _androidImpl?.canScheduleExactNotifications() ?? false;

    await _plugin.zonedSchedule(
      id,
      'Đến giờ ôn tập từ vựng!',
      'Hãy ôn lại từ "$word" ($meaning) bạn vừa lưu 10 phút trước.',
      scheduledDate,
      NotificationDetails(android: details),
      androidScheduleMode: canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  // 3. Lấy danh sách lịch nhắc đang chờ
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _plugin.pendingNotificationRequests();
  }

  // 4. Huỷ một lịch nhắc (dùng cho màn hình PendingNotiScreen)
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const androidInitSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidInitSettings);

    // Từ v20+: dùng tham số có tên
    await _plugin.initialize(settings: initSettings);

    // Quyền thông báo (Android 13+)
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImpl?.requestNotificationsPermission();
  }

  AndroidNotificationDetails _createAndroidDetails({
    required String channelId,
    required String channelName,
    String? channelDescription,
  }) {
    return AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );
  }

  // Gửi thông báo tức thì (Nút 1)
  Future<void> showSimpleNotification({
    int id = 0,
    String title = 'Nhắc học từ vựng',
    String body = 'Bạn đã học 5 từ mới hôm nay chưa?',
  }) async {
    final details = _createAndroidDetails(
      channelId: 'learn_english_channel',
      channelName: 'Học Anh Văn',
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(android: details),
    );
  }

  // Hẹn giờ thông báo (Nút 2 và Nút 3)
  Future<void> scheduleNotificationAfter(
    Duration delay,
    String channelId,
    String channelName,
    String channelDescription, {
    int id = 1, // truyền id khác nhau cho mỗi nút để không ghi đè nhau
  }) async {
    final details = _createAndroidDetails(
      channelId: channelId,
      channelName: channelName,
      channelDescription: channelDescription,
    );

    // Kiểm tra quyền exact alarm (Android 12+), nếu không có thì dùng inexact
    final androidImpl = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final canExact =
        await androidImpl?.canScheduleExactNotifications() ?? false;

    await _plugin.zonedSchedule(
      id: id,
      title: channelName,
      body: channelDescription,
      scheduledDate: tz.TZDateTime.now(tz.local).add(delay),
      notificationDetails: NotificationDetails(android: details),
      androidScheduleMode: canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}

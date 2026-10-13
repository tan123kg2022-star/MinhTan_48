import 'package:flutter/material.dart';

import '../services/notification_service.dart'; // Đảm bảo đường dẫn này đúng

class ScreenNotiEx extends StatelessWidget {
  const ScreenNotiEx({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo và gọi hàm init() cho NotificationService
    NotificationService notificationservice = NotificationService();
    notificationservice.init();

    return Scaffold(
      appBar: AppBar(title: const Text("Screen Noti Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Nút 1: Thông báo ngay lập tức
            ElevatedButton(
              onPressed: () {
                notificationservice.showSimpleNotification();
              },
              child: const Text("Gửi thông báo nhắc học Ngoại ngữ"),
            ),
            const SizedBox(height: 20),

            // Nút 2: Thông báo sau 2 phút
            ElevatedButton(
              onPressed: () {
                notificationservice.scheduleNotificationAfter(
                  const Duration(minutes: 2),
                  'drink_water_channel',
                  'Uống nước',
                  'Nhắc uống nước đúng giờ',
                );
              },
              child: const Text("Gửi thông báo nhắc uống nước sau 2 phút"),
            ),
            const SizedBox(height: 20),

            // Nút 3: Thông báo sau 10 phút (Sinh viên tự làm)
            ElevatedButton(
              onPressed: () {
                notificationservice.scheduleNotificationAfter(
                  const Duration(minutes: 10),
                  'learn_english_delayed_channel',
                  'Nhắc học Ngoại ngữ',
                  'Đã đến giờ học 5 từ vựng mới rồi!',
                );

                // Bật SnackBar để báo hiệu việc lên lịch thành công
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã đặt lịch nhắc học sau 10 phút!'),
                  ),
                );
              },
              child: const Text(
                "Hẹn giờ gửi thông báo học Ngoại ngữ sau 10 phút",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

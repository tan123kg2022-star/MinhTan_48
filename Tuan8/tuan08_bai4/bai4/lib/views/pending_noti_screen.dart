import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:bai4/services/notification_service.dart';

class PendingNotiScreen extends StatefulWidget {
  const PendingNotiScreen({super.key});

  @override
  State<PendingNotiScreen> createState() => _PendingNotiScreenState();
}

class _PendingNotiScreenState extends State<PendingNotiScreen> {
  final NotificationService notiService = NotificationService();
  List<PendingNotificationRequest> pendingList = [];

  @override
  void initState() {
    super.initState();
    loadPending();
  }

  void loadPending() async {
    pendingList = await notiService.getPendingNotifications();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách Lịch nhắc đang chờ'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: pendingList.isEmpty
          ? const Center(child: Text('Hiện không có lịch nhắc nào đang chờ.'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: pendingList.length,
              itemBuilder: (context, index) {
                final item = pendingList[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.schedule, color: Colors.orange),
                    title: Text(item.title ?? 'Lịch nhắc #${item.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(item.body ?? ''),
                    trailing: Text('ID: ${item.id}'),
                  ),
                );
              },
            ),
    );
  }
}
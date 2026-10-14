import 'package:flutter/material.dart';
import 'package:bai4/services/notification_service.dart';
import 'package:bai4/views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notiService = NotificationService();
  await notiService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Học Từ Vựng - Bài 4',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: false,
      ),
      home: const HomeScreen(),
    );
  }
}
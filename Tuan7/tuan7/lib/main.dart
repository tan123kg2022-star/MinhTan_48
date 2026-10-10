import 'package:flutter/material.dart';

import 'route_finder_screen.dart'; // Đảm bảo file mới của bạn có tên này

void main() {
  runApp(RouteFinderApp());
}

class RouteFinderApp extends StatelessWidget {
  const RouteFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Route Finder', home: RouteFinderScreen());
  }
}

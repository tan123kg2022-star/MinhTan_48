import 'package:flutter/material.dart';

//  Import tất cả các bài tập bạn đã tạo vào đây:

import 'baitap_stack.dart';
import 'calculator_page.dart';
import 'huit_bottom_nav.dart';
import 'bai_tap_3.dart';
import 'bai_tap_4.dart';
import 'bai_tap_5.dart';

// import 'calculator_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thực hành Flutter',

      // Bài mẫu
      // home: BaiTapStack(), // Bài mẫu 2
      //Bài 1
      //home: CalculatorPage(),
      //Bài 2
      // home: HuitBottomNavPage(),
      // Bài 3
      // home: BaiTap3Page(),
      //Bài 4
      // home: BaiTap4Page(),
      //Bài 5
      home: BaiTap5Page(),
    );
  }
}

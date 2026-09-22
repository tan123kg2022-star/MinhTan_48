import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyListView(),
    );
  }
}

class MyListView extends StatefulWidget {
  const MyListView({super.key});

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  static const TextStyle _textStyle = TextStyle(
    fontSize: 20,
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ListView Demo"),
        backgroundColor: const Color.fromARGB(255, 239, 168, 4),
        leading: IconButton(icon: const Icon(Icons.home), onPressed: () {}),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Công nghệ phần mềm", style: _textStyle),
            subtitle: const Text(
              "Phát triển các ứng dụng giải quyết các vấn đề thực tế",
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              _showDialog("Thông báo", "Bạn chọn CNPM");
            },
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text("Hệ thống thông tin", style: _textStyle),
            subtitle: const Text(
              "Phát triển các kỹ thuật xử lý thông tin trong tổ chức",
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              _showDialog("Thông báo", "Bạn chọn HTTT");
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text("Mạng máy tính", style: _textStyle),
            subtitle: const Text(
              "Xử lý các vấn đề liên quan đến mạng máy tính",
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              _showDialog("Thông báo", "Bạn chọn MMT");
            },
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text("An toàn thông tin", style: _textStyle),
            subtitle: const Text(
              "Thiết kế và đảm bảo an toàn cho hệ thống máy tính",
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              _showDialog("Thông báo", "Bạn chọn BMTT");
            },
          ),
        ],
      ),
    );
  }
}

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
      home: BaiTap01(),
    );
  }
}

class ChuyenNganh {
  final String ten;
  final String moTa;

  ChuyenNganh({required this.ten, required this.moTa});
}

class BaiTap01 extends StatefulWidget {
  const BaiTap01({super.key});

  @override
  State<BaiTap01> createState() => _BaiTap01State();
}

class _BaiTap01State extends State<BaiTap01> {
  final List<String> dsLoaiDeTai = ['Đồ án', 'KLKS', 'Luận văn', 'Khác'];

  final List<ChuyenNganh> dsChuyenNganh = [
    ChuyenNganh(
      ten: 'Công nghệ phần mềm',
      moTa: 'Phát triển các ứng dụng giải quyết các vấn đề thực tế',
    ),
    ChuyenNganh(
      ten: 'Hệ thống thông tin',
      moTa: 'Phát triển các kỹ thuật xử lý thông tin trong tổ chức',
    ),
    ChuyenNganh(
      ten: 'Mạng máy tính',
      moTa: 'Xử lý các vấn đề liên quan đến mạng máy tính',
    ),
    ChuyenNganh(
      ten: 'An toàn thông tin',
      moTa: 'Thiết kế và đảm bảo an toàn cho hệ thống máy tính',
    ),
  ];

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
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF2196F3),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFA000),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'ListView Demo',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildSectionHeader('Chọn loại đề tài'),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: dsLoaiDeTai.map((loai) {
                return InkWell(
                  onTap: () {
                    _showDialog('Thông báo', 'Bạn chọn loại đề tài: $loai');
                  },
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5E35B1),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black45, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      loai,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          _buildSectionHeader('Chọn chuyên ngành thực hiện'),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              itemCount: dsChuyenNganh.length,
              itemBuilder: (context, index) {
                final cn = dsChuyenNganh[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC7C5B4),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black87, width: 1.2),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 2,
                    ),
                    leading: const Icon(
                      Icons.home,
                      color: Colors.black87,
                      size: 28,
                    ),
                    title: Text(
                      cn.ten,
                      style: const TextStyle(
                        color: Color(0xFFE53935),
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    subtitle: Text(
                      cn.moTa,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 13,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward,
                      color: Colors.black87,
                    ),
                    onTap: () {
                      _showDialog('Thông báo', 'Bạn chọn ${cn.ten}');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

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
      home: MyListDeTai(),
    );
  }
}

//MODEL DỮ LIỆU ĐỀ TÀI

class DeTai {
  final String maDeTai;
  final String tenDeTai;
  final String tenGiangVien;
  final String noiDung;
  final String chuyenNganh;

  DeTai({
    required this.maDeTai,
    required this.tenDeTai,
    required this.tenGiangVien,
    required this.noiDung,
    required this.chuyenNganh,
  });
}

class DeTaiItem extends StatelessWidget {
  final DeTai deTai;

  const DeTaiItem({super.key, required this.deTai});

  static const TextStyle _codeStyle = TextStyle(
    fontSize: 20,
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 8, top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: const Color.fromRGBO(245, 216, 31, 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.school,
              color: Colors.blueAccent,
              size: 36,
            ),
            title: Text(deTai.maDeTai, style: _codeStyle),
            subtitle: Text(
              deTai.tenDeTai,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text(
                      'Thông báo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    content: Text('Bạn chọn: ${deTai.tenDeTai}'),
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
            },
          ),
          const Divider(
            color: Colors.black54,
            height: 10,
            thickness: 1.5,
            indent: 10,
            endIndent: 10,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
            child: Text(
              'Nội dung: ${deTai.noiDung}',
              textAlign: TextAlign.justify,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
            child: Text(
              'Giáo viên: ${deTai.tenGiangVien} - Khoa: ${deTai.chuyenNganh}',
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. MÀN HÌNH CHÍNH (SỬ DỤNG LISTVIEW.BUILDER)
// ==========================================
class MyListDeTai extends StatefulWidget {
  const MyListDeTai({super.key});

  @override
  State<MyListDeTai> createState() => _MyListDeTaiState();
}

class _MyListDeTaiState extends State<MyListDeTai> {
  // Danh sách các đề tài mẫu theo tài liệu
  final List<DeTai> dsDeTai = [
    DeTai(
      maDeTai: "DT01",
      tenDeTai: 'Khai thác tập hữu ích cao trên CSDL giao dịch',
      tenGiangVien: 'ThS. Vũ Văn Vinh',
      noiDung: 'Khai phá tập HUI, tìm hiểu và vận dụng các kỹ thuật tỉa hiệu quả để giảm bớt không gian tìm kiếm.',
      chuyenNganh: 'CNPM',
    ),
    DeTai(
      maDeTai: "DT02",
      tenDeTai: 'Khai tác K tập hữu ích cao nhất (topKHUI)',
      tenGiangVien: 'TS. Vũ Đức Thịnh',
      noiDung: 'Khai phá topKHUI, kết hợp với việc tăng ngưỡng sớm để có được minUtil lớn nhất, từ đó áp dụng các chiến lược tỉa và tăng ngưỡng.',
      chuyenNganh: 'MMT',
    ),
    DeTai(
      maDeTai: "DT03",
      tenDeTai:
          'Phát hiện tấn công và ngăn ngừa phát tán mã độc trong hệ thống mạng',
      tenGiangVien: 'ThS. Vũ Văn Vinh',
      noiDung: 'Áp dụng các mô hình học máy kết hợp giám sát lưu lượng thời gian thực để đưa ra cảnh báo sớm.',
      chuyenNganh: 'CNPM',
    ),
    DeTai(
      maDeTai: "DT04",
      tenDeTai: 'Xây dựng hệ thống thông tin hỗ trợ việc giảng dạy tại HUIT',
      tenGiangVien: 'ThS. Nguyễn Văn Lễ',
      noiDung: 'Xây dựng portal web và mobile app phục vụ việc quản lý lớp học, điểm danh và nộp bài trực tuyến.',
      chuyenNganh: 'HTTT',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh Sách Đề Tài"),
        backgroundColor: const Color.fromARGB(255, 239, 168, 4),
        leading: IconButton(icon: const Icon(Icons.home), onPressed: () {}),
      ),
      body: ListView.builder(
        itemCount: dsDeTai.length,
        itemBuilder: (BuildContext context, int index) {
          return DeTaiItem(deTai: dsDeTai[index]);
        },
      ),
    );
  }
}

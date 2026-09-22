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
      home: ManHinhGioiThieu(),
    );
  }
}

class SanPham {
  final String maSP;
  final String tenSP;
  final String moTa;
  final double gia;
  final String linkAnh;

  SanPham({
    required this.maSP,
    required this.tenSP,
    required this.moTa,
    required this.gia,
    required this.linkAnh,
  });
}

class ManHinhGioiThieu extends StatelessWidget {
  const ManHinhGioiThieu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueAccent, width: 3),
                  color: Colors.white,
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school, size: 55, color: Color(0xFF0D47A1)),
                      Text(
                        'HUIT',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),
              const Text(
                'Cửa hàng điện thoại',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '140 Lê Trọng Tấn, Tân Phú, TP.Hồ Chí Minh',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
              const SizedBox(height: 35),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ManHinhCuaHang(),
                    ),
                  );
                },
                child: Container(
                  width: 58,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.black54,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ManHinhCuaHang extends StatefulWidget {
  const ManHinhCuaHang({super.key});

  @override
  State<ManHinhCuaHang> createState() => _ManHinhCuaHangState();
}

class _ManHinhCuaHangState extends State<ManHinhCuaHang> {
  final List<SanPham> dsSanPham = [
    SanPham(
      maSP: '01',
      tenSP: 'Điện thoại 01',
      moTa: 'điện thoại mới của hãng SamSung với công nghệ hiện đại',
      gia: 1200.0,
      linkAnh:
          'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=300',
    ),
    SanPham(
      maSP: '04',
      tenSP: 'Điện thoại 04',
      moTa: 'điện thoại mới của hãng SamSung với công nghệ hiện đại',
      gia: 602.2,
      linkAnh:
          'https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=300',
    ),
    SanPham(
      maSP: '07',
      tenSP: 'Điện thoại 07',
      moTa: 'điện thoại mới của hãng SamSung với công nghệ hiện đại',
      gia: 2000.0,
      linkAnh:
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=300',
    ),
  ];

  final List<SanPham> gioHang = [];

  void _themVaoGioHang(SanPham sp) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Xác nhận',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Bạn vừa thêm sản phẩm vào Giỏ hàng'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Không', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  gioHang.add(sp);
                });
                Navigator.of(ctx).pop();
              },
              child: const Text(
                'Đồng ý',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _chuyenDenGioHang() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ManHinhGioHang(
          gioHang: gioHang,
          onXoa: (index) {
            setState(() {
              gioHang.removeAt(index);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5B000),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Cửa hàng điện thoại',
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: _chuyenDenGioHang,
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF2196F3),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.blueAccent, width: 2),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.school,
                          size: 40,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Vũ Văn Vinh',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const Text(
                      'vinhvv@huit.edu.vn',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.store, color: Colors.black87),
                title: const Text(
                  'Cửa hàng',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart, color: Colors.black87),
                title: const Text(
                  'Giỏ hàng',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _chuyenDenGioHang();
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.black87),
                title: const Text(
                  'Thoát',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ManHinhGioiThieu(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Center(
                child: Text(
                  'Chọn sản phẩm bạn muốn sử dụng',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 380,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: dsSanPham.length,
                itemBuilder: (context, index) {
                  final sp = dsSanPham[index];
                  return Container(
                    width: 210,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 190,
                            width: double.infinity,
                            color: Colors.black12,
                            child: Image.network(
                              sp.linkAnh,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.phone_android,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          sp.tenSP,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sp.moTa,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${sp.gia}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () => _themVaoGioHang(sp),
                              child: Container(
                                width: 38,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00BFA5),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Sản phẩm được lựa chọn nhiều nhất',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ManHinhGioHang extends StatefulWidget {
  final List<SanPham> gioHang;
  final Function(int) onXoa;

  const ManHinhGioHang({super.key, required this.gioHang, required this.onXoa});

  @override
  State<ManHinhGioHang> createState() => _ManHinhGioHangState();
}

class _ManHinhGioHangState extends State<ManHinhGioHang> {
  void _xacNhanXoa(int index) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Xác nhận',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Bạn muốn loại bỏ sản phẩm này ra khỏi giỏ hàng'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Không', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                widget.onXoa(index);
                setState(() {});
              },
              child: const Text(
                'Đồng ý',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _thanhToan() {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Thanh toán',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text('Bạn đã thanh toán xong giỏ hàng'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5B000),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Giỏ hàng của bạn',
          style: TextStyle(color: Colors.black87, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 14, bottom: 8),
            child: Text(
              'Giỏ hàng của bạn',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ),
          Expanded(
            child: widget.gioHang.isEmpty
                ? const Center(
                    child: Text(
                      'Bạn chưa bỏ sản phẩm nào vô giỏ hàng!!!',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.gioHang.length,
                    itemBuilder: (context, index) {
                      final item = widget.gioHang[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.tenSP,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${item.gia}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.black87,
                                size: 22,
                              ),
                              onPressed: () => _xacNhanXoa(index),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: InkWell(
              onTap: widget.gioHang.isEmpty ? null : _thanhToan,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: const Text(
                  'Thanh toán',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00BFA5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

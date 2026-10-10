import 'package:minhtan_buoi2/SanPham.dart' as sanpham;

void main() {
  sanpham.SanPham sp = sanpham.SanPham();
  sp.showInfo();

  sanpham.SanPham sp1 = sanpham.SanPham.fullPara(
    'SP001',
    'Bánh gạo Nhật',
    25000,
    0,
  );
  sp1.showInfo();
}

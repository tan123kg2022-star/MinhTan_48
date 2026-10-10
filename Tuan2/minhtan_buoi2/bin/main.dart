import 'package:minhtan_buoi2/SanPham.dart' as sanpham;

void main(List<String> args) {
  List<sanpham.SanPham> lstSanPham = [];

  sanpham.SanPham sp1 = sanpham.SanPham.fullPara('SP001', 'Bánh mì', 25000, 0);
  sanpham.SanPham sp2 = sanpham.SanPham.fullPara(
    'SP002',
    'Trà ô long',
    75000,
    0,
  );
  sanpham.SanPham sp3 = sanpham.SanPham.fullPara(
    'SP003',
    'Mứt xoài sấy',
    45000,
    0,
  );

  lstSanPham.add(sp1);
  lstSanPham.add(sp2);
  lstSanPham.add(sp3);

  print("Danh sách sản phẩm là: ");
  for (sanpham.SanPham a in lstSanPham) {
    a.showInfo();
  }
}

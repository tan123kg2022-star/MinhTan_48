import 'dart:io';

void main() {
  stdout.write('Nhap so que kem (>0): ');
  int soLuong = int.parse(stdin.readLineSync()!);

  stdout.write('Nhap gia tien 1 que: ');
  double giaTien = double.parse(stdin.readLineSync()!);

  double tongTien = soLuong * giaTien;

  if (soLuong > 10) {
    tongTien = tongTien * 0.9;
  } else if (soLuong >= 5 && soLuong <= 10) {
    tongTien = tongTien * 0.95;
  }

  print('Tong tien phai tra: $tongTien');
}

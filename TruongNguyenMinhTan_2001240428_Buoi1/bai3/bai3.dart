import 'dart:io';
import 'dart:math';

bool kiemTraSNT(int n) {
  if (n < 2) return false;
  for (int i = 2; i <= sqrt(n); i++) {
    if (n % i == 0) return false;
  }
  return true;
}

void main() {
  List<int> ds = [];

  stdout.write('Nhap so luong phan tu: ');
  int n = int.parse(stdin.readLineSync()!);

  for (int i = 0; i < n; i++) {
    stdout.write('Nhap phan tu ${i + 1}: ');
    ds.add(int.parse(stdin.readLineSync()!));
  }

  print('a. Danh sach vua nhap: $ds');

  int tong = 0;
  for (int i = 0; i < ds.length; i++) {
    tong += ds[i];
  }
  print('b. Tong cac phan tu: $tong');

  stdout.write('c. Cac so nguyen to trong danh sach: ');
  for (int i = 0; i < ds.length; i++) {
    if (kiemTraSNT(ds[i])) {
      stdout.write('${ds[i]} ');
    }
  }
  print('');

  stdout.write('d. Nhap gia tri can tim: ');
  int x = int.parse(stdin.readLineSync()!);

  int viTri = ds.indexOf(x);

  if (viTri != -1) {
    print('Gia tri $x nam o vi tri $viTri trong danh sach.');
  } else {
    ds.insert(0, x);
    print('Gia tri $x khong co, da them vao dau danh sach: $ds');
  }
}

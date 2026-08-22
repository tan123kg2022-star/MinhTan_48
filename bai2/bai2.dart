import 'dart:io';

void main() {
  int n = 0;

  do {
    stdout.write('Nhap so nguyen (> 10): ');
    n = int.parse(stdin.readLineSync()!);
  } while (n <= 10);

  String nStr = n.toString();
  print('a. So chu so: ${nStr.length}');

  int tong = 0;
  bool coSoLe = false;

  for (int i = 0; i < nStr.length; i++) {
    int chuSo = int.parse(nStr[i]);
    tong += chuSo;

    if (chuSo % 2 != 0) {
      coSoLe = true;
    }
  }

  print('b. Tong cac chu so: $tong');

  if (coSoLe) {
    print('c. So nhap vao co chua chu so le.');
  } else {
    print('c. So nhap vao khong chua chu so le.');
  }
}

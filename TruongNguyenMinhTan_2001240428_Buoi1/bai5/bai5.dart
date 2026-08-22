import 'dart:io';

void main() {
  stdout.write('Nhap chuoi: ');
  String chuoi = stdin.readLineSync()!;

  print('a. Chuoi vua nhap: $chuoi');

  int demNguyenAm = 0;
  String nguyenAm = 'aeiouAEIOU';
  for (int i = 0; i < chuoi.length; i++) {
    if (nguyenAm.contains(chuoi[i])) {
      demNguyenAm++;
    }
  }
  print('b. So nguyen am: $demNguyenAm');

  List<String> cacTu = chuoi
      .trim()
      .split(' ')
      .where((e) => e.isNotEmpty)
      .toList();
  print('c. So tu: ${cacTu.length}');

  bool doiXung = true;
  for (int i = 0; i < chuoi.length ~/ 2; i++) {
    if (chuoi[i] != chuoi[chuoi.length - 1 - i]) {
      doiXung = false;
      break;
    }
  }
  print('d. Chuoi co doi xung khong: $doiXung');

  String daoNguoc = cacTu.reversed.join(' ');
  print('e. Dao nguoc tu: $daoNguoc');
}

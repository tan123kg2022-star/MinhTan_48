import 'dart:io';
import 'dart:math';

void main() {
  List<int> ds = [];
  Random rand = Random();

  for (int i = 0; i < 10; i++) {
    ds.add(rand.nextInt(96) + 5);
  }

  print('a. Danh sach: $ds');

  int tongLe = 0;
  int demLe = 0;

  for (int i = 0; i < ds.length; i++) {
    if (ds[i] % 2 != 0) {
      tongLe += ds[i];
      demLe++;
    }
  }

  if (demLe == 0) {
    print('b. Danh sach khong co so le.');
  } else {
    double trungBinhLe = tongLe / demLe;
    print('b. Trung binh cong so le: $trungBinhLe');
  }

  bool doiXung = true;
  int n = ds.length;

  for (int i = 0; i < n ~/ 2; i++) {
    if (ds[i] != ds[n - 1 - i]) {
      doiXung = false;
      break;
    }
  }
  print('c. Danh sach doi xung: $doiXung');

  bool tangDan = true;

  for (int i = 0; i < n - 1; i++) {
    if (ds[i] > ds[i + 1]) {
      tangDan = false;
      break;
    }
  }
  print('d. Danh sach tang dan: $tangDan');

  int max = ds[0];

  for (int i = 1; i < n; i++) {
    if (ds[i] > max) {
      max = ds[i];
    }
  }
  print('e. Phan tu lon nhat: $max');

  int maxChan = -1;
  bool coSoChan = false;

  for (int i = 0; i < n; i++) {
    if (ds[i] % 2 == 0) {
      if (!coSoChan || ds[i] > maxChan) {
        maxChan = ds[i];
        coSoChan = true;
      }
    }
  }

  if (coSoChan) {
    print('f. So chan lon nhat: $maxChan');
  } else {
    print('f. Danh sach khong co so chan.');
  }

  stdout.write('g. Nhap gia tri can tim: ');
  int x = int.parse(stdin.readLineSync()!);

  bool timThay = false;

  for (int i = 0; i < n; i++) {
    if (ds[i] == x) {
      timThay = true;
      break;
    }
  }

  if (timThay) {
    ds.removeWhere((element) => element == x);
    print('Da xoa. Danh sach moi: $ds');
  } else {
    print('Khong tim thay.');
  }
}

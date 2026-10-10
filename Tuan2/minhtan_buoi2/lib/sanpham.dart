git pull origin mainclass SanPham {
  String _maSP = '';
  String _tenSP = '';
  double _donGia = 0;
  double _giamGia = 0;

  SanPham() {
    _maSP = "SP000";
    _tenSP = "Unknown";
    _donGia = 0;
    _giamGia = 0;
  }

  SanPham.fullPara(String masp, String tensp, double gia, double giam) {
    _maSP = masp;
    _tenSP = tensp;
    _donGia = gia;
    _giamGia = giam;
  }

  String get maSP => _maSP;
  set maSP(String value) {
    if (value.isNotEmpty) {
      _maSP = value;
    }
  }

  String get tenSP => _tenSP;
  set tenSP(String value) {
    if (value.isNotEmpty) {
      _tenSP = value;
    }
  }

  // Phương thức get, set cho đơn giá
  double get donGia => _donGia;
  set donGia(double value) {
    if (value > 0) {
      _donGia = value;
    }
  }

  // Bổ sung: get, set cho giảm giá
  double get giamGia => _giamGia;
  set giamGia(double value) {
    if (value >= 0) {
      // Giảm giá thì không nên âm
      _giamGia = value;
    }
  }

  // Phương thức tính thuế nhập khẩu
  double tinhThueNhapKhau() {
    return 0.01 * _donGia;
  }

  // Phương thức hiển thị thông tin
  void showInfo() {
    // Đã đưa toàn bộ chuỗi lên 1 dòng để tránh lỗi ngắt chuỗi sai cú pháp
    print(
      "Mã sản phẩm: $_maSP, tên: $_tenSP, giá bán: $_donGia, giảm giá: $_giamGia, thuế: ${tinhThueNhapKhau()}",
    );
  }
}

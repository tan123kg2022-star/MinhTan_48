import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = "0";
  double _num1 = 0;
  String _operator = "";
  bool _shouldClear = false;

  // Xử lý logic bấm phím cơ bản
  void _onBtnPress(String text) {
    setState(() {
      if (text == "C") {
        _display = "0";
        _num1 = 0;
        _operator = "";
      } else if (text == "CE") {
        _display = "0";
      } else if (text == "⌫") {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = "0";
        }
      } else if (text == "+/-") {
        if (_display != "0") {
          if (_display.startsWith("-")) {
            _display = _display.substring(1);
          } else {
            _display = "-$_display";
          }
        }
      } else if (["+", "-", "×", "÷"].contains(text)) {
        _num1 = double.tryParse(_display) ?? 0;
        _operator = text;
        _shouldClear = true;
      } else if (text == "=") {
        double num2 = double.tryParse(_display) ?? 0;
        double result = 0;
        if (_operator == "+") result = _num1 + num2;
        if (_operator == "-") result = _num1 - num2;
        if (_operator == "×") result = _num1 * num2;
        if (_operator == "÷") {
          if (num2 != 0) {
            result = _num1 / num2;
          } else {
            _display = "Cannot divide by zero";
            return;
          }
        }
        // Làm tròn hiển thị nếu là số nguyên
        if (result == result.roundToDouble()) {
          _display = result.toInt().toString();
        } else {
          _display = result
              .toStringAsFixed(4)
              .replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
        }
        _operator = "";
      } else if (text == ".") {
        if (!_display.contains(".")) {
          _display += ".";
        }
      } else {
        // Nhập số
        if (_display == "0" || _shouldClear) {
          _display = text;
          _shouldClear = false;
        } else {
          _display += text;
        }
      }
    });
  }

  // Widget vẽ từng nút bấm máy tính
  Widget _buildKey(
    String text, {
    Color? bg,
    Color? fg,
    bool isPrimary = false,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => _onBtnPress(text),
          child: Container(
            decoration: BoxDecoration(
              color: isPrimary
                  ? const Color(0xFF0067B8)
                  : (bg ?? const Color(0xFFF9F9F9)),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade300, width: 0.5),
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: (int.tryParse(text) != null || text == "=")
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: isPrimary ? Colors.white : (fg ?? Colors.black87),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget phím nhớ M (MC, MR, M+...)
  Widget _buildMemKey(String text) {
    return Expanded(
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 30),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: const Text(
          "Standard",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_in_picture_alt, size: 20),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.history, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      // Thanh Menu Drawer theo ảnh đề bài
      drawer: Drawer(
        backgroundColor: const Color(0xFFF9F9F9),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Calculator",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Nhóm Calculator
            ListTile(
              leading: const Icon(Icons.calculate, color: Color(0xFF0067B8)),
              title: const Text(
                "Standard",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              selected: true,
              selectedTileColor: Colors.blue.withOpacity(0.08),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.science_outlined),
              title: const Text("Scientific"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text("Graphing"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text("Programmer"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text("Date calculation"),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            // Nhóm Converter
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 4),
              child: Text(
                "Converter",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.currency_exchange),
              title: const Text("Currency"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.view_in_ar),
              title: const Text("Volume"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.straighten),
              title: const Text("Length"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.scale_outlined),
              title: const Text("Weight and mass"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.thermostat),
              title: const Text("Temperature"),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text("Settings"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Màn hình hiển thị số kết quả
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.bottomRight,
                    child: Text(
                      _display,
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),

              // Hàng phím nhớ (MC, MR, M+, ...)
              Row(
                children: [
                  _buildMemKey("MC"),
                  _buildMemKey("MR"),
                  _buildMemKey("M+"),
                  _buildMemKey("M-"),
                  _buildMemKey("MS"),
                  _buildMemKey("M⌄"),
                ],
              ),
              const SizedBox(height: 4),

              // Lưới phím bấm máy tính (6 dòng)
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    // Hàng 1
                    Expanded(
                      child: Row(
                        children: [
                          _buildKey("%"),
                          _buildKey("CE"),
                          _buildKey("C"),
                          _buildKey("⌫"),
                        ],
                      ),
                    ),
                    // Hàng 2
                    Expanded(
                      child: Row(
                        children: [
                          _buildKey("1/x"),
                          _buildKey("x²"),
                          _buildKey("²√x"),
                          _buildKey("÷"),
                        ],
                      ),
                    ),
                    // Hàng 3
                    Expanded(
                      child: Row(
                        children: [
                          _buildKey("7"),
                          _buildKey("8"),
                          _buildKey("9"),
                          _buildKey("×"),
                        ],
                      ),
                    ),
                    // Hàng 4
                    Expanded(
                      child: Row(
                        children: [
                          _buildKey("4"),
                          _buildKey("5"),
                          _buildKey("6"),
                          _buildKey("-"),
                        ],
                      ),
                    ),
                    // Hàng 5
                    Expanded(
                      child: Row(
                        children: [
                          _buildKey("1"),
                          _buildKey("2"),
                          _buildKey("3"),
                          _buildKey("+"),
                        ],
                      ),
                    ),
                    // Hàng 6
                    Expanded(
                      child: Row(
                        children: [
                          _buildKey("+/-"),
                          _buildKey("0"),
                          _buildKey("."),
                          _buildKey("=", isPrimary: true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

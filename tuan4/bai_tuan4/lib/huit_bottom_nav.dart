import 'package:flutter/material.dart';

class HuitBottomNavPage extends StatefulWidget {
  const HuitBottomNavPage({super.key});

  @override
  State<HuitBottomNavPage> createState() => _HuitBottomNavPageState();
}

class _HuitBottomNavPageState extends State<HuitBottomNavPage> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const List<Widget> _widgetOptions = <Widget>[
    Text('HOME PAGE', style: optionStyle),
    Text('COURSE PAGE', style: optionStyle),
    Text('CONTACT HUIT', style: optionStyle),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BottomNavigationBar Demo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),

      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Course'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Contact'),
        ],
        currentIndex: _selectedIndex, // Đánh dấu tab đang chọn
        selectedItemColor: Colors.amber[800], // Màu icon/chữ khi được chọn
        unselectedItemColor: Colors.grey[600], // Màu icon/chữ khi không chọn
        onTap: _onItemTapped, // Gọi hàm chuyển tab
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../widgets/customer_header.dart';
import '../../widgets/customer_menu.dart';

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // TODO: Bạn có thể xử lý điều hướng hoặc thay đổi nội dung theo tab ở đây
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (_selectedIndex) {
      case 0:
        content = Center(child: Text('Home Content'));
        break;
      case 1:
        content = Center(child: Text('Designs Content'));
        break;
      case 2:
        content = Center(child: Text('AR Content'));
        break;
      case 3:
        content = Center(child: Text('Messages Content'));
        break;
      case 4:
        content = Center(child: Text('Profile Content'));
        break;
      default:
        content = Center(child: Text('Home Content'));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: const CustomerHeader(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: content,
      ),
      bottomNavigationBar: CustomerMenu(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

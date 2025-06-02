import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/designer/des_header.dart';
import '../../widgets/designer/des_menu.dart';
import '../../routes/app_routes.dart'; // Đảm bảo bạn có AppRoutes.login

class DesignerProfile extends StatelessWidget {
  const DesignerProfile({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Xóa các thông tin đăng nhập đã lưu
    await prefs.clear(); // hoặc prefs.remove('token') nếu bạn lưu riêng

    // Điều hướng về trang đăng nhập (sửa theo route thực tế của bạn)
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: DesHeader(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Center(
          child: ElevatedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const DesMenu(selectedIndex: 3),
    );
  }
}

import 'package:flutter/material.dart';
import '../../widgets/designer/des_header.dart';
import '../../widgets/designer/des_menu.dart';

class DesignerDashboard extends StatelessWidget {
  const DesignerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: DesHeader(),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Center(child: Text('Dashboard')), // nội dung
      ),
      bottomNavigationBar: const DesMenu(selectedIndex: 0),
    );
  }
}

import 'package:flutter/material.dart';

class CustomerHeader extends StatelessWidget {
  const CustomerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF3F5139);

    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo SnapRoom (text giả lập)
            Text(
              'SnapRoom',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1.2,
              ),
            ),

            // Icons bên phải
            Row(
              children: [
                // Giỏ hàng
                IconButton(
                  onPressed: () {
                    // Xử lý khi nhấn giỏ hàng
                  },
                  icon: const Icon(Icons.shopping_cart),
                  color: Colors.white,
                  tooltip: 'Cart',
                ),

                // Chuông thông báo
                IconButton(
                  onPressed: () {
                    // Xử lý khi nhấn thông báo
                  },
                  icon: const Icon(Icons.notifications),
                  color: Colors.white,
                  tooltip: 'Notifications',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
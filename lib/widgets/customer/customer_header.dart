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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,  
              width: 100,
              child: Image.asset(
                'assets/images/logo_white.png',
                fit: BoxFit.contain,
              ),
            ),

            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // Xử lý khi nhấn giỏ hàng
                  },
                  icon: const Icon(Icons.shopping_cart),
                  color: Colors.white,
                  tooltip: 'Cart',
                ),
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

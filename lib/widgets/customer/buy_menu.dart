import 'package:flutter/material.dart';

class BuyMenu extends StatefulWidget {
  final VoidCallback? onContact;
  final VoidCallback? onAddToCart;
  final VoidCallback? onBuyNow;

  const BuyMenu({
    Key? key,
    this.onContact,
    this.onAddToCart,
    this.onBuyNow,
  }) : super(key: key);

  @override
  State<BuyMenu> createState() => _BuyMenuState();
}

class _BuyMenuState extends State<BuyMenu> {
  int selectedIndex = -1; // -1 nghĩa chưa chọn cái nào

  final Color borderColor = const Color(0xFF3F5139);

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    // Gọi callback tương ứng
    if (index == 0) {
      widget.onContact?.call();
    } else if (index == 1) {
      widget.onAddToCart?.call();
    } else if (index == 2) {
      widget.onBuyNow?.call();
    }
  }

  Widget _buildButton({required int index, required String label, IconData? icon}) {
    final bool isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? borderColor : Colors.white,
            border: Border(
              right: index != 2
                  ? BorderSide(color: borderColor, width: 1)
                  : BorderSide.none,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  color: isSelected ? Colors.white : borderColor,
                  size: 20,
                ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : borderColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        children: [
          _buildButton(index: 0, label: 'Liên hệ', icon: Icons.phone),
          _buildButton(index: 1, label: 'Thêm vào giỏ', icon: Icons.add_shopping_cart),
          _buildButton(index: 2, label: 'Mua ngay', icon: Icons.shopping_bag),
        ],
      ),
    );
  }
}

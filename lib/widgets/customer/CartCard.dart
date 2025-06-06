import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartCard extends StatelessWidget {
  final String productName;
  final int price;       // đơn giá
  final int quantity;
  final int detailPrice; // tổng giá = price * quantity

  const CartCard({
    Key? key,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.detailPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                productName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Đơn giá: ${formatCurrency.format(price)}'),
                Text('Số lượng: $quantity'),
                Text(
                  'Tổng: ${formatCurrency.format(detailPrice)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

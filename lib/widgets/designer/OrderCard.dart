import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../routes/app_routes.dart';  // nhớ import đường dẫn route nếu cần

class OrderCard extends StatelessWidget {
  final dynamic order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = order['id'] ?? 'N/A';
    final status = order['status'] ?? 'Unknown';

    final rawPrice = order['orderPrice'];
    final price = (rawPrice is int || rawPrice is double)
        ? rawPrice
        : int.tryParse(rawPrice.toString()) ?? 0;

    final rawDate = order['date'] as String?;
    DateTime? dateTime;
    if (rawDate != null) {
      dateTime = DateTime.tryParse(rawDate);
    }
    final formattedDate = dateTime != null
        ? DateFormat('dd/MM/yyyy HH:mm').format(dateTime.toLocal())
        : 'N/A';

    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.designerOrderDetail,
          arguments: id,  // truyền id đơn hàng sang màn hình detail
        );
      },
      child: SizedBox(
        height: 170,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.image, size: 40, color: Colors.white),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Mã đơn: $id", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("Tổng giá: ${currencyFormatter.format(price)}"),
                    const SizedBox(height: 4),
                    Text("Trạng thái: $status"),
                    const SizedBox(height: 4),
                    Text("Thời gian: $formattedDate"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

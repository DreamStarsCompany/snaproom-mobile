import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/user_service.dart';
import '../../../routes/app_routes.dart';
import 'CartCard.dart';

class CusCartContent extends StatefulWidget {
  const CusCartContent({Key? key}) : super(key: key);

  @override
  State<CusCartContent> createState() => _CusCartContentState();
}

class _CusCartContentState extends State<CusCartContent> {
  Map<String, dynamic>? cartData;
  bool isLoading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  int parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return 0;
  }

  Future<void> loadCart() async {
    try {
      final response = await UserService.getAllCart();
      if (response != null && response['data'] != null) {
        setState(() {
          cartData = response['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMsg = 'Không có dữ liệu giỏ hàng';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMsg = 'Lỗi khi tải giỏ hàng: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMsg != null) {
      return Center(child: Text(errorMsg!));
    }

    final orderDetails = cartData!['orderDetails'] as List<dynamic>;
    final orderPrice = parseInt(cartData!['orderPrice']);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: orderDetails.length,
            itemBuilder: (context, index) {
              final detail = orderDetails[index];
              final product = detail['product'];

              final price = parseInt(product['price']);
              final quantity = parseInt(detail['quantity']);
              final detailPrice = parseInt(detail['detailPrice']);

              return CartCard(
                productName: product['name'],
                price: price,
                quantity: quantity,
                detailPrice: detailPrice,
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey.shade200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng tiền:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                formatCurrency.format(orderPrice),
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              )
            ],
          ),
        ),
      ],
    );
  }
}

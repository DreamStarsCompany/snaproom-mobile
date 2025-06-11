import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'CartCard.dart';
import '../../services/user_service.dart';
import '../../../routes/app_routes.dart'; // Import đường dẫn route nếu cần

class CusCartContent extends StatefulWidget {
  const CusCartContent({Key? key}) : super(key: key);

  @override
  State<CusCartContent> createState() => _CusCartContentState();
}

class _CusCartContentState extends State<CusCartContent> {
  Map<String, dynamic>? cartData;
  bool isLoading = true;
  String? errorMsg;
  bool hasChanges = false; // << Track if user changed quantity

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  int parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Future<void> loadCart() async {
    try {
      final response = await UserService.getAllCart();
      if (response != null && response['data'] != null) {
        setState(() {
          cartData = response['data'];
          updateTotalPrice();
          isLoading = false;
          hasChanges = false;
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

  void updateTotalPrice() {
    int total = 0;
    for (var detail in cartData!['orderDetails']) {
      final product = detail['product'];
      final price = parseInt(product['price']);
      final quantity = parseInt(detail['quantity']);
      detail['detailPrice'] = price * quantity;
      total += price * quantity;
    }
    cartData!['orderPrice'] = total;
  }

  void onIncreaseQuantity(int index) {
    setState(() {
      cartData!['orderDetails'][index]['quantity']++;
      hasChanges = true;
      updateTotalPrice();
    });
  }

  void onDecreaseQuantity(int index) {
    setState(() {
      int current = parseInt(cartData!['orderDetails'][index]['quantity']);
      if (current > 1) {
        cartData!['orderDetails'][index]['quantity'] = current - 1;
        hasChanges = true;
        updateTotalPrice();
      }
    });
  }

  void onRemoveItem(int index) async {
    final productId = cartData!['orderDetails'][index]['product']['id'];

    try {
      await UserService.removeFromCart(productId);
      setState(() {
        cartData!['orderDetails'].removeAt(index);
        updateTotalPrice();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Xóa sản phẩm thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xóa sản phẩm thất bại: $e')),
      );
    }
  }

  Future<void> saveCartChanges() async {
    try {
      List<Map<String, dynamic>> updatedItems = cartData!['orderDetails'].map<Map<String, dynamic>>((detail) {
        return {
          "productId": detail['product']['id'],
          "quantity": parseInt(detail['quantity']),
        };
      }).toList();

      var response = await UserService.updateCart(updatedItems);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Lưu giỏ hàng thành công')),
      );

      setState(() {
        hasChanges = false;  // Reset lại trạng thái sau khi lưu thành công
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu giỏ hàng: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          splashColor: Colors.grey.withOpacity(0.3),
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.customerHomepage);
          },
        ),
        actions: [
          if (hasChanges)
            Padding(
              padding: const EdgeInsets.only(right: 12), // Khoảng cách bên phải
              child: TextButton(
                onPressed: saveCartChanges,
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF3F5139),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Lưu"),
              ),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMsg != null
          ? Center(child: Text(errorMsg!))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartData!['orderDetails'].length,
              itemBuilder: (context, index) {
                final detail = cartData!['orderDetails'][index];
                final product = detail['product'];
                final isDesign = product['isDesign'] == true;
                final imageUrl = product['primaryImage']?['imageSource'];

                return CartCard(
                  productName: product['name'],
                  productImageUrl: imageUrl,
                  price: parseInt(product['price']),
                  quantity: parseInt(detail['quantity']),
                  detailPrice: parseInt(detail['detailPrice']),
                  isDesign: isDesign,
                  onIncreaseQuantity: () => onIncreaseQuantity(index),
                  onDecreaseQuantity: () => onDecreaseQuantity(index),
                  onRemoveItem: () => onRemoveItem(index),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF3F5139),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng tiền:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  formatCurrency.format(parseInt(cartData!['orderPrice'])),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

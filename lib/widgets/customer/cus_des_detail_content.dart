import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import '../../services/user_service.dart';
import 'buy_menu.dart';

class CusDesDetail extends StatefulWidget {
  final Map<String, dynamic> product;

  const CusDesDetail({Key? key, required this.product}) : super(key: key);

  @override
  State<CusDesDetail> createState() => _CusDesDetailState();
}

class _CusDesDetailState extends State<CusDesDetail> {
  List<dynamic> _furs = [];
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _fetchDesigns();
  }

  Future<void> _fetchDesigns() async {
    final response = await UserService.getAllDesigns();
    if (response != null && response['data'] != null) {
      setState(() {
        _furs = response['data']['items'];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final name = product['name'] ?? '';
    final price = product['price'] ?? 0;
    final rating = product['rating'] ?? 0;
    final imageSource = product['primaryImage']?['imageSource'];
    final description = product['description'] ?? '';

    const mainTextColor = Color(0xFF3F5139);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.customerDesign);
          },
        ),
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 80), // padding đủ cho BuyMenu
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: mainTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    color: const Color(0xFFBCD4B5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: imageSource != null
                          ? Image.network(
                        imageSource,
                        width: double.infinity,
                        height: 270,
                        fit: BoxFit.contain,
                      )
                          : Container(
                        width: double.infinity,
                        height: 220,
                        color: const Color(0xFFBCD4B5),
                        child: const Icon(Icons.image_not_supported, size: 60, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Giá: ${price.toString()}đ',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Mô tả sản phẩm',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          description.isNotEmpty ? description : 'Chưa có mô tả.',
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),

                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 18, color: Colors.orange),
                            const SizedBox(width: 6),
                            Text(
                              '$rating / 5.0',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.zero,
              color: const Color(0xFFF4F4F4),
              height: 10,
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Sản phẩm khác',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: mainTextColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: 250,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _furs.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = _furs[index];
                    final id = item['id'];
                    final name = item['name'] ?? '';
                    final price = item['price'] ?? 0;
                    final rating = item['rating'] ?? 0;
                    final imageSource = item['primaryImage']?['imageSource'];

                    return GestureDetector(
                      onTap: () async {
                        final response = await UserService.getProductById(id);
                        if (response != null && response['data'] != null) {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.customerDesDetail,
                            arguments: response['data'],
                          );
                        }
                      },
                      child: SizedBox(
                        width: 160,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: Container(
                                height: 170,
                                color: const Color(0xFFBCD4B5),
                                child: imageSource != null && imageSource.isNotEmpty
                                    ? Image.network(imageSource, fit: BoxFit.contain)
                                    : const Center(
                                  child: Icon(Icons.image_not_supported, size: 40, color: Colors.white54),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Giá: ${price.toString()}đ',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(Icons.star, size: 12, color: Colors.orange),
                                      const SizedBox(width: 4),
                                      Text('$rating', style: const TextStyle(fontSize: 11)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.zero,
              color: const Color(0xFFF4F4F4),
              height: 10,
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Đánh giá',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: mainTextColor,
                ),
              ),
            ),
            // TODO: Nội dung đánh giá
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12), // chỉ giữ padding trên dưới
        child: SizedBox(
          height: 70, // chỉnh chiều cao phù hợp hơn
          child: BuyMenu(
            onAddToCart: () async {
              try {
                final response = await UserService.addToCart(
                  _quantity,
                  widget.product['id'].toString(),
                );


                if (response != null && response['statusCode'] == 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đã thêm vào giỏ hàng!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Thêm vào giỏ thất bại: ${response['message'] ?? 'Không rõ lỗi'}")),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Vui lòng chọn các sản phẩm có cùng nhà thiết kế")),
                );
              }
            },

            onBuyNow: () {
              print('Mua ngay');
            },
          ),
        ),
      ),

    );
  }
}

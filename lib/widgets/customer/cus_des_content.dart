import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../services/user_service.dart';

class CusDesContent extends StatefulWidget {
  const CusDesContent({Key? key}) : super(key: key);

  @override
  State<CusDesContent> createState() => _CusDesContentState();
}

class _CusDesContentState extends State<CusDesContent> {
  List<dynamic> _designs = [];

  @override
  void initState() {
    super.initState();
    _fetchDesigns();
  }

  Future<void> _fetchDesigns() async {
    final response = await UserService.getAllDesigns();
    if (response != null && response['data'] != null) {
      setState(() {
        _designs = response['data']['items'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ), // Đổi màu icon nếu cần
          splashColor: Colors.grey.withOpacity(0.3), // Màu khi nhấn (bong bóng)
          highlightColor: Colors.transparent, // Màu khi giữ, để trong suốt
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.customerHomepage);
          },
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _designs.length,
        itemBuilder: (context, index) {
          final item = _designs[index];
          final name = item['name'] ?? '';
          final price = item['price'] ?? 0;
          final rating = item['rating'] ?? 0;
          final imageSource =
              item['image'] != null ? item['image']['imageSource'] : null;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child:
                      imageSource != null && imageSource.isNotEmpty
                          ? Image.network(
                            imageSource,
                            height: 150,
                            fit: BoxFit.cover,
                          )
                          : Container(
                            height: 150,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.white54,
                            ),
                          ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Giá: ${price.toString()}đ',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text('$rating', style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

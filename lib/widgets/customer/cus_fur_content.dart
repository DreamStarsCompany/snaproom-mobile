import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../services/user_service.dart';

class CusFurContent extends StatefulWidget {
  const CusFurContent({Key? key}) : super(key: key);

  @override
  State<CusFurContent> createState() => __CusFurContentState();
}

class __CusFurContentState extends State<CusFurContent> {
  List<dynamic> _designs = [];

  @override
  void initState() {
    super.initState();
    _fetchDesigns();
  }

  Future<void> _fetchDesigns() async {
    final response = await UserService.getAllFurnitures();
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

      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.75, // Điều chỉnh tỷ lệ để vừa ảnh và chữ
        ),
        itemCount: _designs.length,
        itemBuilder: (context, index) {
          final item = _designs[index];
          final name = item['name'] ?? '';
          final price = item['price'] ?? 0;
          final rating = item['rating'] ?? 0;
          final imageSource =
              item['image'] != null ? item['image']['imageSource'] : null;

          return Container(
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
                            height: 100,
                            fit: BoxFit.cover,
                          )
                          : Container(
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.white54,
                            ),
                          ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Giá: ${price.toString()}đ',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$rating',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
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

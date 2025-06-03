import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../services/user_service.dart';

class DesFurContent extends StatefulWidget {
  const DesFurContent({Key? key}) : super(key: key);

  @override
  State<DesFurContent> createState() => __DesFurContentState();
}

class __DesFurContentState extends State<DesFurContent> {
  List<dynamic> _designs = [];
  String _sortBy = 'price';
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _fetchFurnitures();
  }

  Future<void> _fetchFurnitures() async {
    final response = await UserService.getAllFurnituresByDes();
    if (response != null && response['data'] != null) {
      setState(() {
        _designs = response['data']['items'];
        _applySorting(); // Sắp xếp khi load lần đầu
      });
    }
  }

  void _applySorting() {
    setState(() {
      _designs.sort((a, b) {
        final aValue = a[_sortBy] ?? 0;
        final bValue = b[_sortBy] ?? 0;
        return _isAscending
            ? aValue.compareTo(bValue)
            : bValue.compareTo(aValue);
      });
    });
  }

  void _onSortChange(String field) {
    setState(() {
      if (_sortBy == field) {
        _isAscending = !_isAscending; // Đảo chiều nếu chọn cùng loại
      } else {
        _sortBy = field;
        _isAscending = true; // Mặc định tăng dần khi đổi field
      }
      _applySorting();
    });
  }

  Widget _buildSortButton(String label, String field) {
    IconData icon = Icons.arrow_downward;
    if (_sortBy == field) {
      icon = _isAscending ? Icons.arrow_upward : Icons.arrow_downward;
    }

    return TextButton.icon(
      onPressed: () => _onSortChange(field),
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: _sortBy == field ? Colors.green : Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            Navigator.pushReplacementNamed(
                context, AppRoutes.designerHomepage);
          },
        ),
      ),
      body: Column(
        children: [
          // Bộ lọc sắp xếp
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortButton('Giá', 'price'),
                  const SizedBox(width: 12),
                  _buildSortButton('Lượt mua', 'purchaseCount'),
                  const SizedBox(width: 12),
                  _buildSortButton('Đánh giá', 'rating'),
                ],
              ),
            ),
          ),

          // Danh sách sản phẩm
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: _designs.length,
              itemBuilder: (context, index) {
                final item = _designs[index];
                final name = item['name'] ?? '';
                final price = item['price'] ?? 0;
                final rating = item['rating'] ?? 0;
                final purchaseCount = item['purchaseCount'] ?? 0;
                final imageSource = item['image']?['imageSource'];

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
                        child: imageSource != null && imageSource.isNotEmpty
                            ? Image.network(
                          imageSource,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          height: 150,
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
          ),
        ],
      ),
    );
  }
}

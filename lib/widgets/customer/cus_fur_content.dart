import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../services/user_service.dart';
import '../../screens/customer/customer_fur_detail.dart';

const Color kPrimaryDarkGreen = Color(0xFF3F5139);


class CusFurContent extends StatefulWidget {
  const CusFurContent({Key? key}) : super(key: key);

  @override
  State<CusFurContent> createState() => __CusFurContentState();
}

class __CusFurContentState extends State<CusFurContent> {
  List<dynamic> _designs = [];
  String _sortBy = 'price';
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _fetchFurnitures();
  }

  Widget _buildSortBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kPrimaryDarkGreen, width: 1),

      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSortOption('Giá', 'price', isFirst: true),
          _buildSortOption('Lượt mua', 'purchaseCount'),
          _buildSortOption('Đánh giá', 'rating', isLast: true),
        ],
      ),
    );
  }

  Widget _buildSortOption(String label, String field, {bool isFirst = false, bool isLast = false}) {
    final bool isActive = _sortBy == field;
    IconData icon = Icons.unfold_more;
    if (isActive) {
      icon = _isAscending ? Icons.arrow_upward : Icons.arrow_downward;
    }

    return Expanded(
      child: InkWell(
        onTap: () => _onSortChange(field),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              right: isLast ? BorderSide.none : BorderSide(color: kPrimaryDarkGreen, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isActive ? kPrimaryDarkGreen : kPrimaryDarkGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                icon,
                size: 16,
                color: isActive ? kPrimaryDarkGreen : kPrimaryDarkGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchFurnitures() async {
    final response = await UserService.getAllFurnitures();
    if (response != null && response['data'] != null) {
      List<dynamic> items = response['data']['items'];

      // Gọi getProductById lần lượt cho từng sản phẩm
      List<dynamic> approvedProducts = [];
      for (var item in items) {
        final detailResponse = await UserService.getProductById(item['id']);
        if (detailResponse != null && detailResponse['data'] != null) {
          final detail = detailResponse['data'];
          if (detail['approved'] == true) {
            approvedProducts.add(item);
          }
        }
      }

      setState(() {
        _designs = approvedProducts;
        _applySorting();
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
        _isAscending = !_isAscending;
      } else {
        _sortBy = field;
        _isAscending = true;
      }
      _applySorting();
    });
  }

  Widget _buildSortButton(String label, String field, {bool isFirst = false, bool isLast = false}) {
    final bool isActive = _sortBy == field;
    IconData icon = Icons.arrow_downward;
    if (isActive) {
      icon = _isAscending ? Icons.arrow_upward : Icons.arrow_downward;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          right: isLast
              ? BorderSide.none
              : BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? Radius.circular(12) : Radius.zero,
          bottomLeft: isFirst ? Radius.circular(12) : Radius.zero,
          topRight: isLast ? Radius.circular(12) : Radius.zero,
          bottomRight: isLast ? Radius.circular(12) : Radius.zero,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.only(
            topLeft: isFirst ? Radius.circular(12) : Radius.zero,
            bottomLeft: isFirst ? Radius.circular(12) : Radius.zero,
            topRight: isLast ? Radius.circular(12) : Radius.zero,
            bottomRight: isLast ? Radius.circular(12) : Radius.zero,
          ),
          onTap: () => _onSortChange(field),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.black87,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  icon,
                  size: 16,
                  color: isActive ? Colors.green : Colors.black54,
                ),
              ],
            ),
          ),
        ),
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
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.customerHomepage);
          },
        ),
      ),
      body: Column(
        children: [
          _buildSortBar(),
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
                        AppRoutes.customerFurDetail,
                        arguments: response['data'],
                      );
                    }
                  },
                  child: Container(
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
                        Container(
                          height: 160,
                          decoration: const BoxDecoration(
                            color: Color(0xFFBCD4B5), // nền xanh nhạt
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: imageSource != null && imageSource.isNotEmpty
                              ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Image.network(
                              imageSource,
                              fit: BoxFit.contain,
                            ),
                          )
                              : const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 40,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Giá: ${price.toString()}đ',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 12,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$rating',
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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

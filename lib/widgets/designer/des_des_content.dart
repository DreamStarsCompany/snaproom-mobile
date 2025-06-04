import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../services/user_service.dart';

class DesDesContent extends StatefulWidget {
  const DesDesContent({Key? key}) : super(key: key);

  @override
  State<DesDesContent> createState() => _DesDesContentState();
}

class _DesDesContentState extends State<DesDesContent> {
  List<dynamic> _designs = [];
  String _sortBy = 'price';
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _fetchDesigns();
  }

  Future<void> _fetchDesigns() async {
    final response = await UserService.getAllDesignsByDes();
    if (response != null && response['data'] != null) {
      setState(() {
        _designs = response['data']['items'];
        _applySorting();
      });
    }
  }

  void _applySorting() {
    setState(() {
      _designs.sort((a, b) {
        final aVal = a[_sortBy] ?? 0;
        final bVal = b[_sortBy] ?? 0;
        return _isAscending ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
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

  Widget _buildSortButton(
      String label,
      String field, {
        bool isFirst = false,
        bool isLast = false,
      }) {
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
          right:
          isLast
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
          splashColor: Colors.grey.withOpacity(0.3),
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRoutes.designerHomepage);
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
                  _buildSortButton('Giá', 'price', isFirst: true),
                  const SizedBox(width: 12),
                  _buildSortButton('Lượt mua', 'purchaseCount'),
                  const SizedBox(width: 12),
                  _buildSortButton('Đánh giá', 'rating', isLast: true),
                ],
              ),
            ),
          ),

          // Danh sách thiết kế
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _designs.length,
              itemBuilder: (context, index) {
                final item = _designs[index];
                final name = item['name'] ?? '';
                final price = item['price'] ?? 0;
                final rating = item['rating'] ?? 0;
                final purchaseCount = item['purchaseCount'] ?? 0;
                final imageSource = item['primaryImage']?['imageSource'];

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
                  child: SizedBox(
                    height: 300, // Chiều cao tổng thể của card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 4, // Tỉ lệ 3 phần ảnh
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            child: Container(
                              color: const Color(0xFFBCD4B5),
                              child: imageSource != null && imageSource.isNotEmpty
                                  ? Image.network(
                                imageSource,
                                width: double.infinity,
                                fit: BoxFit.contain,
                              )
                                  : Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.white54,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 2, // Tỉ lệ 2 phần nội dung
                          child: Padding(
                            padding: const EdgeInsets.all(12),
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
                                const SizedBox(height: 4),
                                Text(
                                  'Giá: ${price.toString()}đ',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$rating',
                                      style: const TextStyle(fontSize: 14),
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

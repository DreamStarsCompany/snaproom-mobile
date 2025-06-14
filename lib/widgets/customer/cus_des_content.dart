import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../../services/user_service.dart';
import 'package:intl/intl.dart';

const Color kPrimaryDarkGreen = Color(0xFF3F5139);

class CusDesContent extends StatefulWidget {
  const CusDesContent({Key? key}) : super(key: key);

  @override
  State<CusDesContent> createState() => _CusDesContentState();
}

String formatCurrency(double amount) {
  final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);
  return formatCurrency.format(amount);
}

class _CusDesContentState extends State<CusDesContent> {
  List<dynamic> _designs = [];
  String _sortBy = 'price';
  bool _isAscending = true;

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
        _applySorting();
      });
    }
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
            Navigator.pushReplacementNamed(context, AppRoutes.customerHomepage);
          },
        ),
      ),
      body: Column(
        children: [
          _buildSortBar(),
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

                return GestureDetector(
                  onTap: () async {
                    final id = item['id'];
                    final response = await UserService.getProductById(
                      id,
                    );
                    if (response != null && response['data'] != null) {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.customerDesDetail,
                        //
                        arguments:
                            response['data'],
                      );
                    }
                  },
                  child: Container(
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
                      height: 300,
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
                                child:
                                    imageSource != null &&
                                            imageSource.isNotEmpty
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
                                    'Giá: ${formatCurrency(price)}',
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

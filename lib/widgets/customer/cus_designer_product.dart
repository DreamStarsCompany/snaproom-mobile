import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../routes/app_routes.dart';
import '../../services/user_service.dart';

const Color kPrimaryDarkGreen = Color(0xFF3F5139);

class CusDesignerProduct extends StatefulWidget {
  final String designerId;

  const CusDesignerProduct({Key? key, required this.designerId})
      : super(key: key);

  @override
  State<CusDesignerProduct> createState() => _CusDesignerProductState();
}

class _CusDesignerProductState extends State<CusDesignerProduct> {
  List<dynamic> _originalList = [];
  List<dynamic> _filteredList = [];
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchDesignerFurnitures();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);
    return formatter.format(amount);
  }

  Future<void> _fetchDesignerFurnitures() async {
    setState(() => _isLoading = true);

    try {
      final response = await UserService.getFurnituresByDesignerId(widget.designerId);
      if (response != null && response['data'] != null) {
        final items = response['data']['items'] ?? [];

        // Lọc các sản phẩm đã được duyệt
        List<dynamic> approved = [];
        for (var item in items) {
          final detail = await UserService.getProductById(item['id']);
          if (detail?['data']?['approved'] == true) {
            approved.add(item);
          }
        }

        setState(() {
          _originalList = approved;
          _filteredList = approved;
        });
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      String keyword = _searchController.text.trim().toLowerCase();
      setState(() {
        _filteredList = _originalList.where((item) {
          return (item['name'] ?? '').toLowerCase().contains(keyword);
        }).toList();
      });
    });
  }

  Widget _buildProductGrid() {
    if (_filteredList.isEmpty) {
      return const Center(
        child: Text('Không tìm thấy sản phẩm', style: TextStyle(fontSize: 16)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: _filteredList.length,
      itemBuilder: (context, index) {
        final item = _filteredList[index];
        final name = item['name'] ?? '';
        final price = item['price'] ?? 0;
        final rating = item['rating'] ?? 0;
        final imageSource = item['primaryImage']?['imageSource'];
        final id = item['id'];

        return GestureDetector(
          onTap: () async {
            final response = await UserService.getProductById(id);
            if (response?['data'] != null) {
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
                    color: Color(0xFFBCD4B5),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: imageSource != null && imageSource.isNotEmpty
                      ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(imageSource, fit: BoxFit.contain),
                  )
                      : const Center(child: Icon(Icons.image_not_supported, size: 40, color: Colors.white54)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 8),
                        Text('Giá: ${formatCurrency(price)}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 12),
                            const SizedBox(width: 4),
                            Text('$rating', style: const TextStyle(fontSize: 11)),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          hintText: 'Tìm kiếm...',
                          fillColor: Colors.grey[200],
                          filled: true,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildProductGrid(),
            ),
          ],
        ),
      ),
    );
  }
}

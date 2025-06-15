import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../../routes/app_routes.dart';
import 'OrderCard.dart';

const Color kPrimaryDarkGreen = Color(0xFF3F5139);

class CusOrderContent extends StatefulWidget {
  const CusOrderContent({Key? key}) : super(key: key);

  @override
  State<CusOrderContent> createState() => _CusOrderContentState();
}

class _CusOrderContentState extends State<CusOrderContent> {
  List<dynamic> _orders = [];
  List<dynamic> _filteredOrders = [];
  bool _isLoading = true;

  String _sortBy = 'orderPrice';  // Đổi đúng key
  bool _isAscending = true;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchOrders();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> fetchOrders() async {
    final response = await UserService.getAllOrdersByCus();
    if (response != null && response['data'] != null) {
      setState(() {
        _orders = response['data']['items'];
        _filteredOrders = List.from(_orders);
        _applySorting();
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      String keyword = _searchController.text.trim().toLowerCase();
      setState(() {
        _filteredOrders = _orders.where((order) {
          final code = (order['id'] ?? '').toString();  // Tìm theo id
          return code.toLowerCase().contains(keyword);
        }).toList();
        _applySorting();
      });
    });
  }

  void _applySorting() {
    setState(() {
      _filteredOrders.sort((a, b) {
        dynamic aValue = a[_sortBy];
        dynamic bValue = b[_sortBy];

        if (_sortBy == 'date') {
          aValue = aValue != null ? DateTime.tryParse(aValue) ?? DateTime(1970) : DateTime(1970);
          bValue = bValue != null ? DateTime.tryParse(bValue) ?? DateTime(1970) : DateTime(1970);
        } else {
          aValue = (aValue is num) ? aValue : num.tryParse(aValue?.toString() ?? '0') ?? 0;
          bValue = (bValue is num) ? bValue : num.tryParse(bValue?.toString() ?? '0') ?? 0;
        }

        int compareResult;
        if (aValue is DateTime && bValue is DateTime) {
          compareResult = aValue.compareTo(bValue);
        } else if (aValue is num && bValue is num) {
          compareResult = aValue.compareTo(bValue);
        } else {
          compareResult = 0;
        }

        return _isAscending ? compareResult : -compareResult;
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
          _buildSortOption('Tổng giá', 'orderPrice', isFirst: true),
          _buildSortOption('Ngày đặt', 'date', isLast: true),
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
                  color: kPrimaryDarkGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, size: 16, color: kPrimaryDarkGreen),
            ],
          ),
        ),
      ),
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
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.customerHomepage);
                    },
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          hintText: 'Tìm kiếm mã đơn hàng...',
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
            _buildSortBar(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = _filteredOrders[index];
                  return OrderCard(order: order);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

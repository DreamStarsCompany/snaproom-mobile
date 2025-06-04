import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting currency and date
import '../../services/user_service.dart';
import '../../../routes/app_routes.dart';  // import app routes
import 'OrderCard.dart';

class CusOrderContent extends StatefulWidget {
  const CusOrderContent({Key? key}) : super(key: key);

  @override
  State<CusOrderContent> createState() => _CusOrderContentState();
}

class _CusOrderContentState extends State<CusOrderContent> {
  List<dynamic> orders = [];
  bool isLoading = true;

  String _sortBy = 'price';
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    final response = await UserService.getAllOrdersByCus();
    if (response != null && response['data'] != null) {
      setState(() {
        orders = response['data']['items'];
        _applySorting();
        isLoading = false;
      });
    }
  }

  void _applySorting() {
    setState(() {
      orders.sort((a, b) {
        dynamic aValue = a[_sortBy];
        dynamic bValue = b[_sortBy];

        // Với ngày thì parse DateTime
        if (_sortBy == 'date') {
          aValue = aValue != null ? DateTime.tryParse(aValue) ?? DateTime(1970) : DateTime(1970);
          bValue = bValue != null ? DateTime.tryParse(bValue) ?? DateTime(1970) : DateTime(1970);
        } else {
          // Nếu không phải số thì chuyển sang 0 để tránh lỗi
          aValue = (aValue is num) ? aValue : 0;
          bValue = (bValue is num) ? bValue : 0;
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
        _isAscending = !_isAscending; // Đảo chiều nếu chọn cùng trường
      } else {
        _sortBy = field;
        _isAscending = true; // Mặc định tăng dần khi đổi trường
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
            Navigator.pushReplacementNamed(context, AppRoutes.customerHomepage);
          },
        ),

      ),
      body: Column(
        children: [
          // Thanh sort
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortButton('Giá', 'price'),
                  const SizedBox(width: 12),
                  _buildSortButton('Ngày', 'date'),
                ],
              ),
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(order: order);
              },
            ),
          ),
        ],
      ),
    );
  }
}

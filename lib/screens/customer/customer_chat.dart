import 'package:flutter/material.dart';
import '../../widgets/customer/cus_chat_content.dart';

class CustomerChat extends StatelessWidget {
  final String conversationId;
  final String senderName;  // Thêm biến này

  const CustomerChat({
    super.key,
    required this.conversationId,
    required this.senderName,   // Thêm biến này
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: CusChatContent(
        conversationId: conversationId,
        senderName: senderName,
      ),
    );
  }
}

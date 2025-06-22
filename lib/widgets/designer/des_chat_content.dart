import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../services/user_service.dart';

class DesChatContent extends StatefulWidget {
  final String conversationId;
  final String senderName;
  const DesChatContent({
    Key? key,
    required this.conversationId,
    required this.senderName,
  }) : super(key: key);

  @override
  State<DesChatContent> createState() => _DesChatContentState();
}

class _DesChatContentState extends State<DesChatContent> {
  List<dynamic> messages = [];
  String conversationId = '';
  String newMessage = '';
  bool isLoading = true;
  String Id = '';

  @override
  void initState() {
    super.initState();
    conversationId = widget.conversationId;
    _loadId();
    fetchConversation();
  }

  Future<void> _loadId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print("Token from SharedPreferences: $token");
    if (token != null && token.isNotEmpty) {
      try {
        final decoded = JwtDecoder.decode(token);
        print("Decoded token payload: $decoded");
        final extractedId = decoded['Id'] ?? decoded['sub'] ?? '';
        print("Extracted user Id: $extractedId");
        setState(() {
          Id = extractedId;
        });
      } catch (e) {
        print("Decode token error: $e");
      }
    } else {
      print("Token is null or empty");
    }
  }

  Future<void> fetchConversation() async {
    setState(() => isLoading = true);
    final data = await UserService.getConversationById(conversationId);
    setState(() {
      messages = (data is Map && data['data'] is List) ? data['data'] : [];
      isLoading = false;
    });
  }

  String formatTime(String iso) {
    final dt = DateTime.parse(iso);
    return DateFormat.Hm().format(dt);
  }

  String formatDate(String iso) {
    final dt = DateTime.parse(iso);
    return DateFormat('dd/MM/yyyy').format(dt);
  }

  Map<String, List<dynamic>> groupByDate(List<dynamic> msgs) {
    Map<String, List<dynamic>> grouped = {};
    for (var msg in msgs) {
      String date = formatDate(msg['createdTime']);
      grouped.putIfAbsent(date, () => []).add(msg);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF3F5139),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.senderName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: groupByDate(messages).entries.toList().reversed.map((entry) {
                  final date = entry.key;
                  final msgs = entry.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            date,
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ),
                      ...msgs.map((msg) {
                        final isOwn = msg['senderId'] == Id;
                        return Row(
                          mainAxisAlignment:
                          isOwn ? MainAxisAlignment.end : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (!isOwn)
                              Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundImage: msg['senderAvatar'] != null
                                      ? NetworkImage(msg['senderAvatar'])
                                      : null,
                                  child: msg['senderAvatar'] == null
                                      ? const Icon(Icons.person, size: 16)
                                      : null,
                                ),
                              ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.all(12),
                              constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.7),
                              decoration: BoxDecoration(
                                color: isOwn ? const Color(0xFF3F5139) : const Color(0xFFF4F4F4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: isOwn
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    msg['content'],
                                    style: TextStyle(
                                      color: isOwn ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    formatTime(msg['createdTime']),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isOwn ? Colors.white70 : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey)),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) => setState(() => newMessage = val),
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Nhập tin nhắn...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF425A41)),
                    onPressed: () {
                      // TODO: Gửi tin nhắn
                      print("Send: $newMessage");
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

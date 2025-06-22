import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  static HubConnection? _connection;
  static bool isConnected = false;

  static Future<void> startConnection(
      String accessToken,
      Function(Map<String, dynamic>) onReceiveMessage,
      ) async {
    if (_connection != null &&
        _connection!.state == HubConnectionState.Connected) {
      print("⚠️ SignalR đã kết nối.");
      return;
    }

    final serverUrl =
        'https://snaproom-e7asc0ercvbxazb8.southeastasia-01.azurewebsites.net/chathub';

    final httpOptions = HttpConnectionOptions(
      accessTokenFactory: () async {
        print("🔑 Đang lấy accessToken cho SignalR...");
        return accessToken;
      },
      skipNegotiation: true, // ✅ Bắt buộc nếu ép WebSockets
      transport: HttpTransportType.WebSockets, // ✅ Ép WebSocket
    );


    print("🛠️ Khởi tạo HubConnection tới $serverUrl...");
    _connection = HubConnectionBuilder()
        .withUrl(serverUrl, options: httpOptions)
        .withAutomaticReconnect()
        .build();

    print("📡 Đăng ký listener ReceiveMessage...");
    _connection!.on("ReceiveMessage", (arguments) {
      print("📥 Nhận được tin nhắn: $arguments");
      try {
        if (arguments != null && arguments.isNotEmpty) {
          final data = arguments.first;
          if (data is Map<String, dynamic>) {
            onReceiveMessage(data);
          } else {
            print("⚠️ ReceiveMessage không phải Map<String, dynamic>: $data");
          }
        }
      } catch (e) {
        print("❌ Lỗi khi xử lý ReceiveMessage: $e");
      }
    });

    // ✅ Các event lifecycle
    _connection!.onclose(({error}) {
      isConnected = false;
      print("🛑 Mất kết nối SignalR. Lỗi: ${error?.toString() ?? 'Không rõ'}");
    });

    _connection!.onreconnecting(({error}) {
      print("🔄 SignalR đang reconnect... Lý do: ${error?.toString() ?? 'Không rõ'}");
    });

    _connection!.onreconnected(({connectionId}) {
      isConnected = true;
      print("🔁 SignalR đã reconnect thành công. ConnectionId: $connectionId");
    });

    try {
      print("🚀 Bắt đầu kết nối...");
      await _connection!.start();
      isConnected = true;
      print("✅ SignalR đã kết nối thành công.");
    } catch (err) {
      isConnected = false;
      print("❌ Lỗi khi kết nối SignalR:");
      print("➡️ Kiểu lỗi: ${err.runtimeType}");
      print("➡️ Nội dung lỗi: $err");
    }
  }

  static Future<void> sendMessage(
      String senderId,
      String receiverId,
      String content,
      ) async {
    print("📤 Chuẩn bị gửi tin nhắn: $content");
    print("🔍 Kết nối: ${_connection?.state}, isConnected: $isConnected");

    if (_connection == null ||
        _connection!.state != HubConnectionState.Connected) {
      print("⚠️ Không thể gửi tin nhắn: chưa kết nối.");
      return;
    }

    try {
      await _connection!.invoke("SendMessage", args: [
        senderId.toString(),
        receiverId.toString(),
        content.toString(),
      ]);

      print("✅ Tin nhắn đã gửi thành công.");
    } catch (err) {
      print("❌ Lỗi khi gửi tin nhắn:");
      print("➡️ Kiểu lỗi: ${err.runtimeType}");
      print("➡️ Nội dung lỗi: $err");
    }
  }

  static Future<void> stopConnection() async {
    if (_connection != null) {
      try {
        print("🔌 Ngắt kết nối SignalR...");
        await _connection!.stop();
        isConnected = false;
        print("✅ Đã ngắt kết nối SignalR.");
      } catch (err) {
        print("❌ Lỗi khi ngắt kết nối:");
        print("➡️ Kiểu lỗi: ${err.runtimeType}");
        print("➡️ Nội dung lỗi: $err");
      }
    } else {
      print("ℹ️ Không có kết nối để ngắt.");
    }
  }
}

// lib/services/user_service.dart
import 'api_service.dart';

class UserService {
  static Future<dynamic> loginDesigner(String email, String password) async {
    return await ApiService.post("/api/auth/designer/login", {
      "email": email,
      "password": password,
    });
  }

  static Future<dynamic> loginCustomer(String email, String password) async {
    return await ApiService.post("/api/auth/customer/login", {
      "email": email,
      "password": password,
    });
  }

  static Future<dynamic> getAllFurnitures({int pageNumber = -1, int pageSize = -1}) async {
    return await ApiService.get("/api/products/furnitures", params: {
      "pageNumber": pageNumber.toString(),
      "pageSize": pageSize.toString(),
    });
  }

  static Future<dynamic> getAllDesigns({int pageNumber = -1, int pageSize = -1}) async {
    return await ApiService.get("/api/products/designs", params: {
      "pageNumber": pageNumber.toString(),
      "pageSize": pageSize.toString(),
    });
  }
}

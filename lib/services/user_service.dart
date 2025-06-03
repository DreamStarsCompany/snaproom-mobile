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
    return await ApiService.get("/api/furnitures", params: {
      "pageNumber": pageNumber.toString(),
      "pageSize": pageSize.toString(),
    });
  }

  static Future<dynamic> getAllDesigns({int pageNumber = -1, int pageSize = -1}) async {
    return await ApiService.get("/api/designs", params: {
      "pageNumber": pageNumber.toString(),
      "pageSize": pageSize.toString(),
    });
  }

  static Future<dynamic> getAllFurnituresByDes({int pageNumber = -1, int pageSize = -1}) async {
    return await ApiService.get("/api/designer/furnitures", params: {
      "pageNumber": pageNumber.toString(),
      "pageSize": pageSize.toString(),
    });
  }

  static Future<dynamic> getAllDesignsByDes({int pageNumber = -1, int pageSize = -1}) async {
    return await ApiService.get("/api/designer/designs", params: {
      "pageNumber": pageNumber.toString(),
      "pageSize": pageSize.toString(),
    });
  }

  static Future<dynamic> getAllOrdersByDes({int pageNumber = -1, int pageSize = -1}) async {
    return await ApiService.get("/api/designer/orders", params: {
      "pageNumber": pageNumber.toString(),
      "pageSize": pageSize.toString(),
    });
  }

  static Future<dynamic> getOrderById({required String id}) async {
    return await ApiService.get("/api/orders/$id");
  }

  static Future<dynamic> registerDesigner({
    required String name,
    required String email,
    required String password,
    required String applicationUrl,
  }) async {
    return await ApiService.post(
      "/api/auth/designer/register",
      {
        "name": name,
        "email": email,
        "password": password,
        "applicattionUrl": applicationUrl,
      },
    );
  }

  static Future<dynamic> registerCustomer({
    required String name,
    required String email,
    required String password,
  }) async {
    return await ApiService.post(
      "/api/auth/customer/register",
      {
        "name": name,
        "email": email,
        "password": password,
      },
    );
  }



}

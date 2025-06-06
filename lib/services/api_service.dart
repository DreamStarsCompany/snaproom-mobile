// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import 'package:flutter/material.dart';

class ApiService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<dynamic> get(String endpoint, {Map<String, String>? params}) async {
    final uri = Uri.parse('$apiBaseUrl$endpoint').replace(queryParameters: params);
    final token = await getToken();

    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });

    return _handleResponse(response);
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('$apiBaseUrl$endpoint');
    final token = await getToken();

    final response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body));

    return _handleResponse(response);
  }

  // Thêm phương thức delete
  static Future<dynamic> delete(String endpoint, {Map<String, String>? params}) async {
    final uri = Uri.parse('$apiBaseUrl$endpoint').replace(queryParameters: params);
    final token = await getToken();

    final response = await http.delete(uri, headers: {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    });

    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      Fluttertoast.showToast(msg: "Hết phiên đăng nhập. Vui lòng đăng nhập lại.");
      // TODO: Chuyển hướng về login nếu cần
    }
    // else {
    //   debugPrint("API Error: ${response.statusCode} - ${response.body}");
    //   Fluttertoast.showToast(msg: "Đã có lỗi xảy ra. Vui lòng thử lại.");
    // }

    throw Exception("Failed request: ${response.statusCode}");
  }
}

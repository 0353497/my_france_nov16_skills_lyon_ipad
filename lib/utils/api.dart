import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiHelper {
  // ignore: non_constant_identifier_names
  static String BASE_URL = "http://152.70.59.133:3000";

  static Future<Map<String, dynamic>> signIn(
    String email,
    String password,
  ) async {
    final url = Uri.parse('$BASE_URL/api/diary');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"userEmailAddress": email, "userPassword": password}),
    );
    debugPrint(response.body);

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getDiaries() async {
    final url = Uri.parse('$BASE_URL/api/diary');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> insertFavorite(
    String authToken,
    String diaryId,
  ) async {
    final url = Uri.parse('$BASE_URL/api/diary/collection');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json', "auth_token": authToken},
      body: jsonEncode({"diary_id": diaryId}),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getFavorites(String authToken) async {
    final url = Uri.parse('$BASE_URL/api/diary/collection');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json', "auth_token": authToken},
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getResource(String path) async {
    final url = Uri.parse('$BASE_URL/api/$path');

    final response = await http.get(url);

    return jsonDecode(response.body);
  }

  static Future<String> getUserAgreement() async {
    final url = Uri.parse('$BASE_URL/api/user-agreement');

    final response = await http.get(url);

    return response.body;
  }

  static Future<List> readAssetJson(String path) async {
    final data = await rootBundle.loadString(path);
    return jsonDecode(data);
  }
}

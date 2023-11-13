import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mage/data/constants/system.dart';

Future<T> getService<T>(
  T Function(Map<String, dynamic>) fromJson,
  String apiPath, [
  Map<String, dynamic>? query,
]) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? 'Basic your_api_token_here';

    final response = await http.get(
      Uri.https(host, apiPath, query), // 本地改为 Uri.https(host, apiPath, query)
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: token,
      },
    );

    if (response.statusCode == 200) {
      return fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed');
    }
  } catch (e) {
    throw Exception('Failed');
  }
}

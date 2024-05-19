import 'dart:convert';
import 'package:flutter_application/models/user.dart';
import 'package:http/http.dart' as http;

class UsersApiService {
  final String baseUrl = 'http://192.168.0.109/users';

  Future<Map<String, String>> login(String username, String password) async {
    var url = Uri.parse('$baseUrl/login');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return {
        "message": 'Login successful',
      };
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<User> createUser(String name, String email, String password) async {
    var url = Uri.parse(baseUrl);
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user: ${response.body}');
    }
  }
}

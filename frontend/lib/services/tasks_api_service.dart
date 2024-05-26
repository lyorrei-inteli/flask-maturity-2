import 'dart:convert';
import 'dart:io';
import 'package:flutter_application/models/task.dart';
import 'package:http/http.dart' as http;

class TasksApiService {
  final String baseUrl = 'http://192.168.205.134/tasks';

  Future<List<Task>> getTasks() async {
    var url = Uri.parse('$baseUrl');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((task) => Task.fromJson(task)).toList();
    } else {
      throw Exception('Failed to load tasks from API');
    }
  }

  Future<Task> createTask(String text) async {
    var url = Uri.parse('$baseUrl');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'text': text,
        'status': false,
      }),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task: ${response.body}');
    }
  }

  Future<void> updateTaskName(int taskId, String name) async {
    var url = Uri.parse('$baseUrl/$taskId');
    var response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'text': name,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task status: ${response.body}');
    }
  }

  Future<void> updateTaskStatus(int taskId, bool newStatus) async {
    var url = Uri.parse('$baseUrl/$taskId');
    var response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'status': newStatus,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task status: ${response.body}');
    }
  }

  Future<void> deleteTask(int taskId) async {
    var url = Uri.parse('$baseUrl/$taskId');
    var response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task: ${response.body}');
    }
  }

  Future<File> removeBackground(File imageFile) async {
    print(baseUrl);
    final String base64Image = base64Encode(await imageFile.readAsBytes());
    print(base64Image);
    final String apiUrl = '$baseUrl/image/remove-background';
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'image': base64Image}),
    );

    print(response);

    if (response.statusCode == 200) {
      return File.fromRawPath(response.bodyBytes);
    } else {
      throw Exception('Failed to remove background: ${response.body}');
    }
  }
}

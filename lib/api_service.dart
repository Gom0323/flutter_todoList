import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://192.168.0.27:3001/api';
  String? cookies;

  ApiService() {
    _loadCookies();
  }

  Future<void> _loadCookies() async {
    final prefs = await SharedPreferences.getInstance();
    cookies = prefs.getString('cookies');
  }

  Future<Map<String, String>> _getHeaders() async {
    if (cookies == null) {
      await _loadCookies();
    }
    return {
      'Content-Type': 'application/json',
      'cookie': cookies ?? '',
    };
  }

  void _logRequest(String method, String url, Map<String, String> headers,
      [String? body]) {
    print('REQUEST[$method] => URL: $url');
    print('Request Headers: $headers');
    if (body != null) {
      print('Request Body: $body');
    }
  }

  void _logResponse(http.Response response) {
    print('RESPONSE[${response.statusCode}] => URL: ${response.request?.url}');
    print('Response Headers: ${response.headers}');
    print('Response Body: ${response.body}');
  }

  Future<List<Map<String, dynamic>>> fetchDiaryTasks() async {
    final url = '$baseUrl/diary_tasks';
    final headers = await _getHeaders();

    _logRequest('GET', url, headers);

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    _logResponse(response);

    if (response.statusCode == 200) {
      List tasks = json.decode(response.body);
      return tasks.map((task) => task as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load diary tasks');
    }
  }

  Future<void> addDiaryTask(Map<String, dynamic> task) async {
    final url = '$baseUrl/diary_tasks';
    final headers = await _getHeaders();
    final body = json.encode(task);

    _logRequest('POST', url, headers, body);

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    _logResponse(response);

    if (response.statusCode != 201) {
      throw Exception('Failed to add diary task');
    }
  }

  Future<void> updateDiaryTask(int id, Map<String, dynamic> task) async {
    final url = '$baseUrl/diary_tasks/$id';
    final headers = await _getHeaders();
    final body = json.encode(task);

    _logRequest('PUT', url, headers, body);

    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    _logResponse(response);

    if (response.statusCode != 200) {
      throw Exception('Failed to update diary task');
    }
  }

  Future<void> deleteDiaryTask(int id) async {
    final url = '$baseUrl/diary_tasks/$id';
    final headers = await _getHeaders();

    _logRequest('DELETE', url, headers);

    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    _logResponse(response);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete diary task');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCalendarTasks() async {
    final url = '$baseUrl/calendar_tasks';
    final headers = await _getHeaders();

    _logRequest('GET', url, headers);

    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );

    _logResponse(response);

    if (response.statusCode == 200) {
      List tasks = json.decode(response.body);
      return tasks.map((task) => task as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load calendar tasks');
    }
  }

  Future<void> addCalendarTask(Map<String, dynamic> task) async {
    final url = '$baseUrl/calendar_tasks';
    final headers = await _getHeaders();
    final body = json.encode(task);

    _logRequest('POST', url, headers, body);

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    _logResponse(response);

    if (response.statusCode != 201) {
      throw Exception('Failed to add calendar task');
    }
  }

  Future<void> updateCalendarTask(int id, Map<String, dynamic> task) async {
    final url = '$baseUrl/calendar_tasks/$id';
    final headers = await _getHeaders();
    final body = json.encode(task);

    _logRequest('PUT', url, headers, body);

    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    _logResponse(response);

    if (response.statusCode != 200) {
      throw Exception('Failed to update calendar task');
    }
  }

  Future<void> deleteCalendarTask(int id) async {
    final url = '$baseUrl/calendar_tasks/$id';
    final headers = await _getHeaders();

    _logRequest('DELETE', url, headers);

    final response = await http.delete(
      Uri.parse(url),
      headers: headers,
    );

    _logResponse(response);

    if (response.statusCode != 204) {
      throw Exception('Failed to delete calendar task');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.0.31:3001'; // Node.js 서버의 IP 주소 및 포트

  // Diary Tasks
  Future<List<Map<String, dynamic>>> fetchDiaryTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/diary_tasks'));

    if (response.statusCode == 200) {
      List tasks = json.decode(response.body);
      print('Fetched diary tasks: $tasks'); // 디버깅을 위해 추가
      return tasks.map((task) => task as Map<String, dynamic>).toList();
    } else {
      print('Failed to load diary tasks: ${response.reasonPhrase}');
      print('Response body: ${response.body}'); // 응답 본문 출력
      throw Exception('Failed to load diary tasks');
    }
  }

  Future<void> addDiaryTask(Map<String, dynamic> task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/diary_tasks'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task),
    );

    if (response.statusCode != 201) {
      print('Failed to add diary task: ${response.reasonPhrase}');
      print('Response body: ${response.body}'); // 응답 본문 출력
      throw Exception('Failed to add diary task');
    }
  }

  Future<void> updateDiaryTask(int id, Map<String, dynamic> task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/diary_tasks/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task),
    );

    if (response.statusCode != 200) {
      print('Failed to update diary task: ${response.reasonPhrase}');
      print('Response body: ${response.body}'); // 응답 본문 출력
      throw Exception('Failed to update diary task');
    }
  }

  Future<void> deleteDiaryTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/diary_tasks/$id'));

    if (response.statusCode != 204) {
      print('Failed to delete diary task: ${response.reasonPhrase}');
      print('Response body: ${response.body}'); // 응답 본문 출력
      throw Exception('Failed to delete diary task');
    }
  }

  // Calendar Tasks
  Future<List<Map<String, dynamic>>> fetchCalendarTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/calendar_tasks'));

    if (response.statusCode == 200) {
      List tasks = json.decode(response.body);
      print('Fetched calendar tasks: $tasks'); // 디버깅을 위해 추가
      return tasks.map((task) => task as Map<String, dynamic>).toList();
    } else {
      print('Failed to load calendar tasks: ${response.reasonPhrase}');
      print('Response body: ${response.body}'); // 응답 본문 출력
      throw Exception('Failed to load calendar tasks');
    }
  }

  Future<void> addCalendarTask(Map<String, dynamic> task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/calendar_tasks'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task),
    );

    if (response.statusCode != 201) {
      print('Failed to add calendar task: ${response.reasonPhrase}');
      print('Response body: ${response.body}'); // 응답 본문 출력
      throw Exception('Failed to add calendar task');
    }
  }

  Future<void> updateCalendarTask(int id, Map<String, dynamic> task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/calendar_tasks/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(task),
    );

    if (response.statusCode != 200) {
      print('Failed to update calendar task: ${response.reasonPhrase}');
      print('Response body: ${response.body}'); // 응답 본문 출력
      throw Exception('Failed to update calendar task');
    }
  }

  Future<void> deleteCalendarTask(int id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/calendar_tasks/$id'));

    if (response.statusCode != 204) {
      print('Failed to delete calendar task: ${response.reasonPhrase}');
      print('Response body: ${response.body}'); // 응답 본문 출력
      throw Exception('Failed to delete calendar task');
    }
  }
}

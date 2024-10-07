import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/onprogress_model.dart';
late String baseUrl = 'https://66c2cc9cd057009ee9bdf06e.mockapi.io/api';

class ApiServiceOnProgress {
  // Fetch data
  static Future<List<OnProgress>> fetchProject() async {
    final response = await http.get(Uri.parse('$baseUrl/project'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Mapping
      List<OnProgress> projects =
          data.map((json) => OnProgress.fromJson(json)).toList();
      return projects;
    } else {
      throw Exception('Failed to load project');
    }
  }

  // Add data
  static Future<OnProgress> addProject(OnProgress project) async {
    final response = await http.post(
      Uri.parse('$baseUrl/project'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(project.toJson()),
    );

    if (response.statusCode == 201) {
      return OnProgress.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add project');
    }
  }

  // Delete data
  static Future<void> deleteProject(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/project/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete project');
    }
  }
}

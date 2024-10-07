import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/projectdone_model.dart'; // Import your ProjectDone model

late String baseUrl = 'https://66c2cc9cd057009ee9bdf06e.mockapi.io/api';

class ApiServiceProjectDone {
  // Fetch data
  static Future<List<ProjectDone>> fetchProjectDone() async {
    final response = await http.get(Uri.parse('$baseUrl/project-done'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      // Mapping
      return data.map((json) => ProjectDone.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load project');
    }
  }

  // Add data
  static Future<ProjectDone> addProjectDone(ProjectDone project) async {
    final response = await http.post(
      Uri.parse('$baseUrl/project-done'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(project.toJson()),
    );

    if (response.statusCode == 201) {
      return ProjectDone.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add project');
    }
  }

  // Delete data
  static Future<void> deleteProjectDone(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/project-done/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete project');
    }
  }
}

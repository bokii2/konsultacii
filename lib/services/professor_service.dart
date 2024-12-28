import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:konsultacii/config/api_config.dart';
import 'package:konsultacii/models/response/professor_response.dart';

class ProfessorService {
  final client = http.Client();

  final headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json; charset=UTF-8',
  };

  Future<List<ProfessorResponse>> getProfessors() async {
    try {
      final response = await client.get(
          Uri.parse('${ApiConfig.baseUrl}/professors/'),
          headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => ProfessorResponse.fromJson(json))
            .toList();
      } else {
        throw HttpException('Failed to load consultations');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
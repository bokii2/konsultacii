import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:konsultacii/config/api_config.dart';
import 'package:konsultacii/models/response/ConsultationsResponse.dart';

class ConsultationService {
  final client = http.Client();

  final headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json; charset=UTF-8',
  };

  Future<List<ConsultationResponse>> getUpcomingConsultations() async {
    try {
      final response = await client.get(
          Uri.parse('${ApiConfig.baseUrl}/consultations/upcoming'),
          headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => ConsultationResponse.fromJson(json))
            .toList();
      } else {
        throw HttpException('Failed to load consultations');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<DateTime>> getDaysOfUpcomingConsultations() async {
    try {
      final response = await client.get(
          Uri.parse('${ApiConfig.baseUrl}/consultations/upcoming/days'),
          headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((dateString) => DateTime.parse(dateString))
            .toList();
      } else {
        throw HttpException('Failed to load consultations');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<ConsultationResponse>> getAllConsultationsByDateAndProfessorId(DateTime? date, String? professorId) async {
    try {
      final dateParam = date != null ? DateFormat('yyyy-MM-dd').format(date) : '';
      final professorParam = professorId ?? '';

      final response = await client.get(
          Uri.parse('${ApiConfig.baseUrl}/consultations/upcoming')
              .replace(queryParameters: {
            if (date != null) 'date': dateParam,
            if (professorId != null) 'professorId': professorParam,
          }),
          headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => ConsultationResponse.fromJson(json))
            .toList();
      } else {
        throw HttpException('Failed to load consultations');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:konsultacii/config/api_config.dart';
import 'package:konsultacii/models/request/schedule_consultation_request.dart';
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

  Future<List<ConsultationResponse>> getAllConsultationsByDateAndProfessorId(
      DateTime? date, String? professorId) async {
    try {
      final dateParam =
          date != null ? DateFormat('yyyy-MM-dd').format(date) : '';
      final professorParam = professorId ?? '';

      final response = await client.get(
          Uri.parse('${ApiConfig.baseUrl}/consultations')
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

  Future<ConsultationResponse> updateConsultation(
    int consultationId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final response = await client.patch(
        Uri.parse('${ApiConfig.baseUrl}/consultations/$consultationId'),
        headers: {
          'Content-Type': 'application/json',
          // Add any authorization headers if needed
          // 'Authorization': 'Bearer $token',
        },
        body: json.encode(updateData),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ConsultationResponse.fromJson(jsonData);
      } else {
        throw HttpException(
          'Failed to update consultation. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error updating consultation: ${e.toString()}');
    }
  }

  Future<bool> scheduleConsultations(ScheduleConsultationRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/consultations/schedule'),
        headers: headers,
        body: json.encode({
          ...request.toJson()
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        final errors = json.decode(response.body)['errors'];
      }
      throw Exception('Failed to schedule consultation');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> cancelConsultations(int termId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/consultations/${termId}/cancel'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        final errors = json.decode(response.body)['errors'];
      }
      throw Exception('Failed to cancel consultation');
    } catch (e) {
      rethrow;
    }
  }
}

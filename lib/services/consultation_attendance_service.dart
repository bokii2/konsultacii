import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:konsultacii/config/api_config.dart';
import 'package:konsultacii/models/request/consultations_form_dto.dart';
import 'package:konsultacii/models/response/ConsultationsResponse.dart';
import 'package:konsultacii/models/response/consultation_attendance_response.dart';

class ConsultationAttendanceService {
  final client = http.Client();

  final headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json; charset=UTF-8',
  };

  Future<List<ConsultationAttendanceResponse>> getAllAttendancesForSlot(
      {required int id}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/consultations/attendance/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => ConsultationAttendanceResponse.fromJson(json))
            .toList();
      } else if (response.statusCode == 400) {
        final errors = json.decode(response.body)['errors'];
      }
      throw Exception('Failed to edit consultation');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> reportStudentAbsence(
      {required int id, required String? comment}) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${ApiConfig.baseUrl}/consultations/attendance/report-student-absence/$id'),
        headers: headers,
        body: json.encode({'absentStudentComment': comment}),
      );

      if (response.statusCode == 200) {
        print("STATUS 200");
      } else if (response.statusCode == 400) {
        final errors = json.decode(response.body)['errors'];
      } else {
        throw Exception('Failed to report absent student');
      }
    } catch (e) {
      rethrow;
    }
  }
}

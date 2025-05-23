import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:konsultacii/config/api_config.dart';
import 'package:konsultacii/models/request/consultations_form_dto.dart';
import 'package:konsultacii/models/request/irregular_consultations_request.dart';
import 'package:konsultacii/models/response/ConsultationsResponse.dart';

class ManageConsultationService {
  final client = http.Client();

  final headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json; charset=UTF-8',
  };


  Future<ConsultationResponse> editConsultation({
    required int id,
    required ConsultationFormDto consultationForm,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${ApiConfig.baseUrl}/manage-consultations/edit-consultation/$id?professorId=test'),
        headers: headers,
        body: json.encode({
          ...consultationForm.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        print(response.body);
        return ConsultationResponse.fromJson(json.decode(response.body));
      } else if (response.statusCode == 400) {
        final errors = json.decode(response.body)['errors'];
      }
      throw Exception('Failed to edit consultation');
    } catch (e) {
      rethrow;
    }
  }


  Future<ConsultationResponse> createIrregularConsultations({
    required String professorId,
    required IrregularConsultationsRequest request,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
            '${ApiConfig.baseUrl}/manage-consultations/$professorId/create-irregular-consultations'),
        headers: headers,
        body: json.encode({
          ...request.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        print(response.body);
        return ConsultationResponse.fromJson(json.decode(response.body));
      } else if (response.statusCode == 400) {
        final errors = json.decode(response.body)['errors'];
      }
      throw Exception('Failed to edit consultation');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteConsultation({
    required int id}) async {
    try {
      final response = await http.delete(
        Uri.parse(
            '${ApiConfig.baseUrl}/manage-consultations/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        final errors = json.decode(response.body)['errors'];
      }
      throw Exception('Failed to edit consultation');
    } catch (e) {
      rethrow;
    }
  }

}

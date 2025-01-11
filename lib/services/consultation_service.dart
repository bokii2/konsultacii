import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:konsultacii/config/api_config.dart';
import 'package:konsultacii/models/message.dart';
import 'package:konsultacii/models/request/schedule_consultation_request.dart';
import 'package:konsultacii/models/response/ConsultationsResponse.dart';

import '../models/exceptions/api_exception.dart';

class ConsultationService {
  final http.Client _client;
  final String _baseUrl;

  static final _dateFormatter = DateFormat('yyyy-MM-dd');

  ConsultationService({
    http.Client? client,
    String? baseUrl,
  }) : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? ApiConfig.baseUrl;

  final _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json; charset=UTF-8',
  };

  T _handleResponseWithBody<T>(
      http.Response response,
      T Function(dynamic json) parser
      ) {
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw ApiException('Unexpected empty response body');
      }

      try {
        final dynamic jsonData = jsonDecode(response.body);
        return parser(jsonData);
      } catch (e) {
        throw ApiException('Failed to parse response: $e');
      }
    }
    _handleErrorResponse(response);
  }

  void _handleStatusOnlyResponse(http.Response response) {
    if (response.statusCode != 200) {
      _handleErrorResponse(response);
    }
  }

  Never _handleErrorResponse(http.Response response) {
    Map<String, dynamic>? errors;
    String message = 'Request failed';

    if (response.statusCode == 400 && response.body.isNotEmpty) {
      try {
        final responseData = jsonDecode(response.body);
        if (responseData case {'errors': Map<String, dynamic> errorMap}) {
          errors = errorMap;
          if (errorMap case {'message': String errorMessage}) {
            message = errorMessage;
          }
        }
      } catch (_) {
        // If parsing fails, use default error message
      }
    }

    throw ApiException(
      message,
      statusCode: response.statusCode,
      errors: errors,
    );
  }

  @override
  Future<List<ConsultationResponse>> getUpcomingConsultations() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/consultations/upcoming'),
        headers: _headers,
      );

      return _handleResponseWithBody(response, (json) {
        if (json is! List) throw ApiException('Expected a list of consultations');
        return json.map((item) => ConsultationResponse.fromJson(item)).toList();
      });
    } catch (e) {
      throw ApiException('Failed to get upcoming consultations: $e');
    }
  }


  @override
  Future<List<Message>> getCommentsForConulstationTerm(int termId) async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/consultations/${termId}/comments'),
        headers: _headers,
      );

      return _handleResponseWithBody(response, (json) {
        if (json is! List) throw ApiException('Expected a list of comments');
        return json.map((item) => Message.fromJson(item)).toList();
      });
    } catch (e) {
      throw ApiException('Failed to get comments: $e');
    }
  }

  @override
  Future<void> addCommentForConulstationTerm(int attendanceId, String comment) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/consultations/${attendanceId}/comment?comment=${comment}'),
        headers: _headers,
      );

      _handleStatusOnlyResponse(response);
    } catch (e) {
      throw ApiException('Failed to add comment: $e');
    }
  }

  @override
  Future<List<DateTime>> getDaysOfUpcomingConsultations() async {
    try {
      final response = await _client.get(
        Uri.parse('$_baseUrl/consultations/upcoming/days'),
        headers: _headers,
      );

      return _handleResponseWithBody(response, (json) {
        if (json is! List) throw ApiException('Expected a list of dates');
        return json.map((dateString) {
          if (dateString is! String) throw ApiException('Invalid date format');
          return DateTime.parse(dateString);
        }).toList();
      });
    } catch (e) {
      throw ApiException('Failed to get consultation days: $e');
    }
  }

  @override
  Future<List<ConsultationResponse>> getAllConsultationsByDateAndProfessorId(
      DateTime? date,
      String? professorId,
      ) async {
    try {
      final queryParams = <String, String>{
        if (date != null) 'date': _dateFormatter.format(date),
        if (professorId != null) 'professorId': professorId,
      };

      final response = await _client.get(
        Uri.parse('$_baseUrl/consultations').replace(queryParameters: queryParams),
        headers: _headers,
      );

      return _handleResponseWithBody(response, (json) {
        if (json is! List) throw ApiException('Expected a list of consultations');
        return json.map((item) => ConsultationResponse.fromJson(item)).toList();
      });
    } catch (e) {
      throw ApiException('Failed to get consultations: $e');
    }
  }

  @override
  Future<List<ConsultationResponse>> getMyConsultationsByProfessorId(
      String? professorId,
      ) async {
    try {
      final queryParams = <String, String>{
        if (professorId != null) 'professorId': professorId,
      };

      final response = await _client.get(
        Uri.parse('$_baseUrl/consultations/booked').replace(queryParameters: queryParams),
        headers: _headers,
      );

      return _handleResponseWithBody(response, (json) {
        if (json is! List) throw ApiException('Expected a list of consultations');
        return json.map((item) => ConsultationResponse.fromJson(item)).toList();
      });
    } catch (e) {
      throw ApiException('Failed to get consultations: $e');
    }
  }

  @override
  Future<ConsultationResponse> updateConsultation(
      int consultationId,
      Map<String, dynamic> updateData,
      ) async {
    try {
      final response = await _client.patch(
        Uri.parse('$_baseUrl/consultations/$consultationId'),
        headers: _headers,
        body: jsonEncode(updateData),
      );

      return _handleResponseWithBody(
        response,
            (json) => ConsultationResponse.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      throw ApiException('Failed to update consultation: $e');
    }
  }

  @override
  Future<void> scheduleConsultations(ScheduleConsultationRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/consultations/schedule'),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      _handleStatusOnlyResponse(response);
    } catch (e) {
      throw ApiException('Failed to schedule consultation: $e');
    }
  }

  @override
  Future<void> cancelConsultations(int termId) async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/consultations/$termId/cancel'),
        headers: _headers,
      );

      _handleStatusOnlyResponse(response);
    } catch (e) {
      throw ApiException('Failed to cancel consultation: $e');
    }
  }

  /// Cleanup resources when the service is no longer needed
  void dispose() {
    _client.close();
  }
}
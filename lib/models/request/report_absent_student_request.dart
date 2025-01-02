import 'package:flutter/material.dart';

class ReportAbsentStudentRequest {
  final int attendanceId;
  final String? comment;

  ReportAbsentStudentRequest({
    required this.attendanceId,
    required this.comment,
  });

  Map<String, dynamic> toJson() => {
        'absentStudentComment': comment,
      };
}

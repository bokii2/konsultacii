import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IrregularConsultationsRequest {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String? roomName;
  final bool online;
  final String? studentInstructions;
  final String? link;
  final DateTime date;

  IrregularConsultationsRequest({
    required this.startTime,
    required this.endTime,
    this.roomName,
    required this.online,
    this.studentInstructions,
    this.link,
    required this.date,
  });

  static String _timeOfDayToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static TimeOfDay _stringToTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  static String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Parse date from yyyy-MM-dd
  static DateTime _parseDate(String date) {
    return DateFormat('yyyy-MM-dd').parse(date);
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': _timeOfDayToString(startTime),
      'endTime': _timeOfDayToString(endTime),
      'roomName': roomName,
      'online': online,
      'studentInstructions': studentInstructions,
      'link': link,
      'date': _formatDate(date),
    };
  }

  factory IrregularConsultationsRequest.fromJson(Map<String, dynamic> json) {
    return IrregularConsultationsRequest(
      startTime: _stringToTimeOfDay(json['startTime']),
      endTime: _stringToTimeOfDay(json['endTime']),
      roomName: json['roomName'],
      online: json['online'],
      studentInstructions: json['studentInstructions'],
      link: json['link'],
      date: json['date'],
    );
  }
}

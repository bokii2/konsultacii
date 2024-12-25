import 'package:flutter/material.dart';

class ConsultationFormDto {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String roomName;
  final bool online;
  final String studentInstructions;
  final Uri? link;
  final DateTime date;

  ConsultationFormDto({
    required this.startTime,
    required this.endTime,
    required this.roomName,
    required this.online,
    required this.studentInstructions,
    required this.date,
    this.link,
  });

  Map<String, dynamic> toJson() => {
        'startTime': timeOfDayToString(startTime),
        'endTime': timeOfDayToString(endTime),
        'roomName': roomName,
        'online': online,
        'studentInstructions': studentInstructions,
        'date': date.toIso8601String().split('T')[0]
      };

  factory ConsultationFormDto.fromJson(Map<String, dynamic> json) {
    return ConsultationFormDto(
      startTime: _parseTimeOfDay(json['startTime']),
      endTime: _parseTimeOfDay(json['endTime']),
      roomName: json['roomName'],
      online: json['online'],
      studentInstructions: json['studentInstructions'],
      link: Uri.parse(json['link']),
      date: DateTime.parse(json['date']),
    );
  }

  static TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  static String timeOfDayToString(TimeOfDay time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}

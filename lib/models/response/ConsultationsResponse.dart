import 'package:flutter/material.dart';
import 'package:konsultacii/models/enum/ConsultationStatus.dart';

class ConsultationResponse {
  final int id;
  final String professor;
  final String room;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final ConsultationStatus status;
  final bool? online;
  final String studentInstruction;
  final bool isCancelled;
  final bool isBooked;

  ConsultationResponse({
    required this.id,
    required this.professor,
    required this.room,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.online,
    required this.studentInstruction,
    required this.isCancelled,
    required this.isBooked,
  });

  factory ConsultationResponse.fromJson(Map<String, dynamic> json) {
    return ConsultationResponse(
      id: json['id'],
      professor: json['professor'],
      room: json['room'],
      date: DateTime.parse(json['date']),
      startTime: _parseTimeOfDay(json['startTime']),
      endTime: _parseTimeOfDay(json['endTime']),
      status: ConsultationStatus.values.byName(json['status']),
      online: json['online'],
      studentInstruction: json['studentInstruction'],
      isCancelled: json['isCancelled'],
      isBooked: json['isBooked']
    );
  }

  static TimeOfDay _parseTimeOfDay(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'professor': professor,
    'room': room,
    'date': date.toIso8601String(),
    'startTime': '${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}:00',
    'endTime': '${endTime.hour}:${endTime.minute.toString().padLeft(2, '0')}:00',
    'status': status.name,
    'online': online,
    'studentInstruction': studentInstruction,
    'isCancelled': isCancelled,
    'isBooked': isBooked
  };

  ConsultationResponse copyWith({
    int? id,
    String? professor,
    String? room,
    DateTime? date,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    ConsultationStatus? status,
    bool? online,
    String? studentInstruction,
    bool? isCancelled,
    bool? isBooked,
  }) {
    return ConsultationResponse(
      id: id ?? this.id,
      professor: professor ?? this.professor,
      room: room ?? this.room,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      online: online ?? this.online,
      studentInstruction: studentInstruction ?? this.studentInstruction,
      isCancelled: isCancelled ?? this.isCancelled,
      isBooked: isBooked ?? this.isBooked
    );
  }
}

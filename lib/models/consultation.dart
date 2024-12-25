// lib/models/consultation.dart
import 'package:konsultacii/models/enum/ConsultationStatus.dart';

class Consultation {
  final String id;
  final String professorId;
  final String professorName;
  DateTime dateTime;
  final int durationMinutes;
  String location;
  ConsultationStatus status;
  String comment;

  Consultation({
    required this.id,
    required this.professorId,
    required this.professorName,
    required this.dateTime,
    required this.durationMinutes,
    required this.location,
    this.status = ConsultationStatus.ACTIVE,
    this.comment = "",
  });

  bool get isEditable {
    if (dateTime.isBefore(DateTime.now())) return false;
    return status == ConsultationStatus.ACTIVE;
  }

  bool get isCancellable {
    if (dateTime.isBefore(DateTime.now())) return false;
    return status == ConsultationStatus.ACTIVE;
  }

  void book({
    required String studentId,
    required String studentName,
    required String subject,
    required String reason,
  }) {
    this.status = ConsultationStatus.ACTIVE;
  }

  void cancel() {
    if (status == ConsultationStatus.ACTIVE) {
      status = ConsultationStatus.INACTIVE;
    }
  }

  void markProfessorUnavailable() {
    status = ConsultationStatus.INACTIVE;
  }

  void updateDetails({
    DateTime? newDateTime,
    String? newLocation,
    String? newComment,
  }) {
    if (newDateTime != null) {
      dateTime = newDateTime;
    }
    if (newLocation != null) {
      location = newLocation;
    }
    if (newComment != null) {
      comment = newComment;
    }
  }
}
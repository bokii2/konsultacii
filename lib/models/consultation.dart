// lib/models/consultation.dart
enum ConsultationStatus {
  available,
  booked,
  completed,
  cancelled,
  professorUnavailable
}

class Consultation {
  final String id;
  final String professorId;
  final String professorName;
  DateTime dateTime;
  final int durationMinutes;
  String location;
  String? studentId;
  String? studentName;
  ConsultationStatus status;
  String comment;
  String? subject;
  String? bookingReason;
  DateTime? bookedAt;
  DateTime? lastModified;

  Consultation({
    required this.id,
    required this.professorId,
    required this.professorName,
    required this.dateTime,
    required this.durationMinutes,
    required this.location,
    this.studentId,
    this.studentName,
    this.status = ConsultationStatus.available,
    this.comment = "",
    this.subject,
    this.bookingReason,
    this.bookedAt,
    this.lastModified,
  });

  bool get isEditable {
    if (dateTime.isBefore(DateTime.now())) return false;
    return status == ConsultationStatus.booked ||
        status == ConsultationStatus.available;
  }

  bool get isCancellable {
    if (dateTime.isBefore(DateTime.now())) return false;
    return status == ConsultationStatus.booked ||
        status == ConsultationStatus.available;
  }

  void book({
    required String studentId,
    required String studentName,
    required String subject,
    required String reason,
  }) {
    this.studentId = studentId;
    this.studentName = studentName;
    this.subject = subject;
    this.bookingReason = reason;
    this.status = ConsultationStatus.booked;
    this.bookedAt = DateTime.now();
    this.lastModified = DateTime.now();
  }

  void cancel() {
    if (status == ConsultationStatus.booked) {
      status = ConsultationStatus.available;
      studentId = null;
      studentName = null;
      subject = null;
      bookingReason = null;
      bookedAt = null;
      lastModified = DateTime.now();
    }
  }

  void markProfessorUnavailable() {
    status = ConsultationStatus.professorUnavailable;
    lastModified = DateTime.now();
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
    lastModified = DateTime.now();
  }
}
// lib/services/consultation_service.dart
import '../models/consultation.dart';

class ConsultationService {
  static final ConsultationService _instance = ConsultationService._internal();
  factory ConsultationService() => _instance;
  ConsultationService._internal();

  final List<Consultation> _consultations = [];

  // Get consultations
  List<Consultation> getAllConsultations() => _consultations;

  List<Consultation> getConsultationsForProfessor(String professorId) {
    return _consultations
        .where((consultation) => consultation.professorId == professorId)
        .toList();
  }

  List<Consultation> getConsultationsForStudent(String studentId) {
    return _consultations
        .where((consultation) => consultation.studentId == studentId)
        .toList();
  }

  // Consultation management
  void addConsultation(Consultation consultation) {
    _consultations.add(consultation);
  }

  void deleteConsultation(String consultationId) {
    _consultations.removeWhere((consultation) => consultation.id == consultationId);
  }

  void updateConsultation(String consultationId, Map<String, dynamic> updates) {
    final index = _consultations.indexWhere((c) => c.id == consultationId);
    if (index != -1) {
      final consultation = _consultations[index];

      if (updates.containsKey('dateTime')) {
        consultation.updateDetails(
          newDateTime: updates['dateTime'] as DateTime,
          newLocation: updates['location'] as String?,
          newComment: updates['comment'] as String?,
        );
      }

      if (updates['status'] == ConsultationStatus.professorUnavailable) {
        consultation.markProfessorUnavailable();
      }

      if (updates['status'] == ConsultationStatus.available) {
        consultation.cancel();
      }

      if (updates.containsKey('studentId')) {
        consultation.book(
          studentId: updates['studentId'] as String,
          studentName: updates['studentName'] as String,
          subject: updates['subject'] as String,
          reason: updates['reason'] as String,
        );
      }
    }
  }

  // Utility methods
  bool isTimeSlotAvailable(DateTime dateTime, String professorId) {
    return !_consultations.any((consultation) =>
        consultation.professorId == professorId &&
        consultation.dateTime == dateTime &&
        (consultation.status == ConsultationStatus.booked ||
         consultation.status == ConsultationStatus.professorUnavailable));
  }

  List<Consultation> getAvailableConsultations(
    DateTime startDate,
    DateTime endDate,
    String? professorId,
    String? subject,
  ) {
    return _consultations.where((consultation) {
      if (consultation.status != ConsultationStatus.available) return false;
      if (consultation.dateTime.isBefore(startDate) ||
          consultation.dateTime.isAfter(endDate)) return false;
      if (professorId != null && consultation.professorId != professorId) {
        return false;
      }
      if (subject != null && consultation.subject != subject) return false;
      return true;
    }).toList();
  }

  // Statistics and analytics
  Map<String, int> getConsultationStatistics(String professorId) {
    final professorConsultations = getConsultationsForProfessor(professorId);

    return {
      'total': professorConsultations.length,
      'booked': professorConsultations
          .where((c) => c.status == ConsultationStatus.booked)
          .length,
      'completed': professorConsultations
          .where((c) => c.status == ConsultationStatus.completed)
          .length,
      'cancelled': professorConsultations
          .where((c) => c.status == ConsultationStatus.cancelled)
          .length,
      'unavailable': professorConsultations
          .where((c) => c.status == ConsultationStatus.professorUnavailable)
          .length,
    };
  }

  List<MapEntry<DateTime, int>> getConsultationTrends(
    String professorId,
    DateTime startDate,
    DateTime endDate,
  ) {
    final consultations = getConsultationsForProfessor(professorId)
        .where((c) =>
            c.dateTime.isAfter(startDate) && c.dateTime.isBefore(endDate))
        .toList();

    final Map<DateTime, int> dailyCounts = {};
    for (var consultation in consultations) {
      final date = DateTime(
        consultation.dateTime.year,
        consultation.dateTime.month,
        consultation.dateTime.day,
      );
      dailyCounts[date] = (dailyCounts[date] ?? 0) + 1;
    }

    return dailyCounts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
  }
}
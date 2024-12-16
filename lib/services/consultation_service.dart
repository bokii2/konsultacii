// lib/services/consultation_service.dart
import '../models/consultation.dart';

// lib/services/consultation_service.dart
class ConsultationService {
  static final ConsultationService _instance = ConsultationService._internal();
  factory ConsultationService() => _instance;
  ConsultationService._internal();

  final List<Consultation> _consultations = [
    // Add some initial consultations
    Consultation(
      id: '1',
      professorId: 'prof1',
      professorName: 'Проф1',
      dateTime: DateTime.now().add(const Duration(days: 1)),
      durationMinutes: 30,
      location: '315',
      status: ConsultationStatus.available,
    ),
  ];

  // Updated method to get all consultations
  List<Consultation> getAllConsultations() => List.from(_consultations);

  // Method to get available consultations with filters
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
      if (professorId != null && professorId != 'Сите' &&
          consultation.professorId != professorId) {
        return false;
      }
      if (subject != null && subject != 'Сите' &&
          consultation.subject != subject) return false;
      return true;
    }).toList();
  }

  // Method to get consultations for a professor
  List<Consultation> getConsultationsForProfessor(String professorId) {
    return _consultations
        .where((consultation) => consultation.professorId == professorId)
        .toList();
  }

  // Update the consultation
  void updateConsultation(String consultationId, Map<String, dynamic> updates) {
    final index = _consultations.indexWhere((c) => c.id == consultationId);
    if (index != -1) {
      final consultation = _consultations[index];

      if (updates.containsKey('studentId')) {
        consultation.book(
          studentId: updates['studentId'],
          studentName: updates['studentName'],
          subject: updates['subject'],
          reason: updates['reason'],
        );
      }

      if (updates.containsKey('dateTime')) {
        consultation.updateDetails(
          newDateTime: updates['dateTime'],
          newLocation: updates['location'],
          newComment: updates['comment'],
        );
      }

      if (updates.containsKey('status')) {
        consultation.status = updates['status'];
      }
      _consultations[index] = consultation;
    }
  }

  void addConsultation(Consultation consultation) {
    _consultations.add(consultation);
  }

  void deleteConsultation(String id) {
    _consultations.removeWhere((c) => c.id == id);
  }
}
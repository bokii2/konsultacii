// lib/screens/consultation_students/consultation_students_screen.dart
import 'package:flutter/material.dart';

import '../../models/consultation.dart';
import '../../utils/date_formatter.dart';

class ConsultationStudentsScreen extends StatelessWidget {
  final Consultation consultation;

  const ConsultationStudentsScreen({
    Key? key,
    required this.consultation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0099FF),
        title: const Text(
          'Закажани студенти',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConsultationInfo(),
          const Divider(),
          Expanded(
            child: _buildStudentsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormatter.formatDateTime(consultation.dateTime),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000066),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Просторија: ${consultation.location}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          if (consultation.comment.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Коментар: ${consultation.comment}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStudentsList() {
    // Here you would get all students for this consultation
    // For now, we'll show the single booked student
    if (consultation.studentId == null) {
      return const Center(
        child: Text('Нема закажани студенти'),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStudentCard(
          studentName: consultation.studentName ?? 'Непознат студент',
          subject: consultation.subject ?? 'Непознат предмет',
          reason: consultation.bookingReason ?? '',
        ),
      ],
    );
  }

  Widget _buildStudentCard({
    required String studentName,
    required String subject,
    required String reason,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.person, color: Color(0xFF0099FF)),
                const SizedBox(width: 8),
                Text(
                  studentName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.book, color: Color(0xFF0099FF)),
                const SizedBox(width: 8),
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            if (reason.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.comment, color: Color(0xFF0099FF)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      reason,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
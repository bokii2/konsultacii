import 'package:flutter/material.dart';
import '../../models/response/ConsultationsResponse.dart';
import '../../utils/date_formatter.dart';

class BookConsultationConfirmDialog extends StatelessWidget {
  final ConsultationResponse consultation;

  const BookConsultationConfirmDialog({
    super.key,
    required this.consultation,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Потврда за закажување',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF000066),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Дали сте сигурни дека сакате да ја закажете оваа консултација?',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          _buildConsultationDetails(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Откажи',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0099FF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text(
            'Закажи',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildConsultationDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Професор:', consultation.professor),
          const SizedBox(height: 8),
          _buildDetailRow('Просторија:', consultation.room),
          const SizedBox(height: 8),
          _buildDetailRow(
            'Датум:',
            DateFormatter.formatDate(consultation.date),
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            'Време:',
            '${consultation.startTime.hour.toString().padLeft(2, '0')}:${consultation.startTime.minute.toString().padLeft(2, '0')} - ${consultation.endTime.hour.toString().padLeft(2, '0')}:${consultation.endTime.minute.toString().padLeft(2, '0')}',
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
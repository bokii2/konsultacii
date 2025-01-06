import 'package:flutter/material.dart';
import 'package:konsultacii/models/response/ConsultationsResponse.dart';

import '../../utils/date_formatter.dart';

class ProfessorCancelConsultationDialog extends StatelessWidget {
  final ConsultationResponse consultation;

  const ProfessorCancelConsultationDialog({
    Key? key,
    required this.consultation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.event_busy,
              color: Colors.orange,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Откажи термин',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000066),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Дали сте сигурни дека сакате да го откажете овој термин?\n\n'
                  'Датум: ${DateFormatter.formatDate(consultation.date)}\n'
                  'Време: ${DateFormatter.formatTime(consultation.date)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Откажи'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Потврди'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
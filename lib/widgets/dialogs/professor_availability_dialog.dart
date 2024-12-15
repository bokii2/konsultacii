import 'package:flutter/material.dart';

import '../../models/consultation.dart';
import '../../utils/date_formatter.dart';

class ProfessorAvailabilityDialog extends StatelessWidget {
  final Consultation consultation;

  const ProfessorAvailabilityDialog({
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
              'Означи како неслободен',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000066),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Дали сте сигурни дека сакате да го означите овој термин како неслободен?\n\n'
                  'Датум: ${DateFormatter.formatDate(consultation.dateTime)}\n'
                  'Време: ${DateFormatter.formatTime(consultation.dateTime)}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Откажи'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
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
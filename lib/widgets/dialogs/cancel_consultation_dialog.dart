// lib/widgets/dialogs/cancel_consultation_dialog.dart
import 'package:flutter/material.dart';
import '../../models/consultation.dart';
import '../../utils/date_formatter.dart';

class CancelConsultationDialog extends StatelessWidget {
  final Consultation consultation;

  const CancelConsultationDialog({
    Key? key,
    required this.consultation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildWarningIcon(),
            const SizedBox(height: 16),
            _buildTitle(),
            const SizedBox(height: 16),
            _buildMessage(),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWarningIcon() {
    return const Icon(
      Icons.warning_rounded,
      color: Colors.orange,
      size: 48,
    );
  }

  Widget _buildTitle() {
    return const Text(
      'Откажи консултација',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF000066),
      ),
    );
  }

  Widget _buildMessage() {
    return Text(
      'Дали сте сигурни дека сакате да ја откажете консултацијата на ${DateFormatter.formatDateTime(consultation.dateTime)}?',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: Text(
            'Назад',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Откажи',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    );
  }
}
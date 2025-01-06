import 'package:flutter/material.dart';
import 'package:konsultacii/models/request/schedule_consultation_request.dart';
import '../../models/response/ConsultationsResponse.dart';
import '../../utils/date_formatter.dart';

class BookConsultationConfirmDialog extends StatefulWidget {
  final ConsultationResponse consultation;

  const BookConsultationConfirmDialog({
    super.key,
    required this.consultation,
  });

  @override
  _BookConsultationConfirmDialogState createState() =>
      _BookConsultationConfirmDialogState();
}

class _BookConsultationConfirmDialogState
    extends State<BookConsultationConfirmDialog> {
  final _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _reasonController.text = '';
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

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
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Дали сте сигурни дека сакате да ја закажете оваа консултација?',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildConsultationDetails(),
            const SizedBox(height: 16),
            _buildCommentField()
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(
            'Откажи',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(ScheduleConsultationRequest(
            termId: widget.consultation.id,
            comment: _reasonController.text
          )),
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
          _buildDetailRow('Професор:', widget.consultation.professor),
          const SizedBox(height: 8),
          _buildDetailRow('Просторија:', widget.consultation.room),
          const SizedBox(height: 8),
          _buildDetailRow(
            'Датум:',
            DateFormatter.formatDate(widget.consultation.date),
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            'Време:',
            '${widget.consultation.startTime.hour.toString().padLeft(2, '0')}:${widget.consultation.startTime.minute.toString().padLeft(2, '0')} - ${widget.consultation.endTime.hour.toString().padLeft(2, '0')}:${widget.consultation.endTime.minute.toString().padLeft(2, '0')}',
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

  Widget _buildCommentField() {
    return TextField(
      controller: _reasonController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Коментар',
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xFF0099FF),
            width: 2,
          ),
        ),
        errorText: _reasonController.text.isEmpty ? 'Задолжително поле' : null,
      ),
    );
  }
}

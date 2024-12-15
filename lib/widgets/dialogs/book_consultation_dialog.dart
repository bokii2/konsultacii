// lib/widgets/dialogs/book_consultation_dialog.dart
import 'package:flutter/material.dart';
import '../../models/consultation.dart';
import '../../utils/date_formatter.dart';

class BookConsultationDialog extends StatefulWidget {
  final Consultation consultation;

  const BookConsultationDialog({
    Key? key,
    required this.consultation,
  }) : super(key: key);

  @override
  _BookConsultationDialogState createState() => _BookConsultationDialogState();
}

class _BookConsultationDialogState extends State<BookConsultationDialog> {
  final _reasonController = TextEditingController();
  String? selectedSubject;
  final List<String> subjects = ['Предмет 1', 'Предмет 2', 'Предмет 3'];

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildConsultationInfo(),
            const SizedBox(height: 16),
            _buildSubjectDropdown(),
            const SizedBox(height: 16),
            _buildReasonField(),
            const SizedBox(height: 24),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Закажи консултација',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Color(0xFF000066),
      ),
    );
  }

  Widget _buildConsultationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Професор: ${widget.consultation.professorName}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Датум: ${DateFormatter.formatDate(widget.consultation.dateTime)}',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          'Време: ${DateFormatter.formatTime(widget.consultation.dateTime)}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildSubjectDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Изберете предмет',
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
      ),
      value: selectedSubject,
      items: subjects.map((subject) {
        return DropdownMenuItem(
          value: subject,
          child: Text(subject),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedSubject = value;
        });
      },
    );
  }

  Widget _buildReasonField() {
    return TextField(
      controller: _reasonController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Причина за консултација',
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
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          child: Text(
            'Откажи',
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
            backgroundColor: const Color(0xFF0099FF),
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
            'Потврди',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () => _handleConfirm(context),
        ),
      ],
    );
  }

  void _handleConfirm(BuildContext context) {
    if (selectedSubject != null && _reasonController.text.isNotEmpty) {
      Navigator.pop(context, true);
    }
  }
}
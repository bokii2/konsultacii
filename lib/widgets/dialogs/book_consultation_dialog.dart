// lib/widgets/dialogs/book_consultation_dialog.dart
import 'package:flutter/material.dart';
import 'package:konsultacii/models/response/ConsultationsResponse.dart';
import '../../models/consultation.dart';
import '../../utils/date_formatter.dart';

class BookConsultationDialog extends StatefulWidget {
  final ConsultationResponse consultation;

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
  void initState() {
    super.initState();
    // Initialize with existing values if available
    // selectedSubject = widget.consultation.subject;
    _reasonController.text = widget.consultation.studentInstruction ?? '';
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
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
          'Професор: ${widget.consultation.professor}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Датум: ${DateFormatter.formatDate(widget.consultation.date)}',
          style: const TextStyle(fontSize: 16),
        ),
        Text(
          'Време: ${DateFormatter.formatTime(widget.consultation.date)}',
          style: const TextStyle(fontSize: 16),
        ),
        if (widget.consultation.room.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Просторија: ${widget.consultation.room}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
        if (widget.consultation.studentInstruction.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Коментар: ${widget.consultation.studentInstruction}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
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
        errorText: selectedSubject == null ? 'Задолжително поле' : null,
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
        errorText: _reasonController.text.isEmpty ? 'Задолжително поле' : null,
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
      Map<String, dynamic> result = {
        'subject': selectedSubject,
        'reason': _reasonController.text,
      };
      Navigator.of(context).pop(result);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Ве молиме пополнете ги сите полиња'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
}
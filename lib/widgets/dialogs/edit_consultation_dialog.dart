import 'package:flutter/material.dart';
import '../../models/consultation.dart';
import '../../utils/date_formatter.dart';

class EditConsultationDialog extends StatefulWidget {
  final Consultation consultation;
  final bool isProfessor;

  const EditConsultationDialog({
    Key? key,
    required this.consultation,
    this.isProfessor = false,
  }) : super(key: key);

  @override
  _EditConsultationDialogState createState() => _EditConsultationDialogState();
}

class _EditConsultationDialogState extends State<EditConsultationDialog> {
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  late TextEditingController locationController;
  late TextEditingController commentController;
  late TextEditingController reasonController;
  String? selectedSubject;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.consultation.dateTime;
    selectedTime = TimeOfDay.fromDateTime(widget.consultation.dateTime);
    locationController = TextEditingController(text: widget.consultation.location);
    commentController = TextEditingController(text: widget.consultation.comment);
    reasonController = TextEditingController(text: widget.consultation.bookingReason);
    selectedSubject = widget.consultation.subject;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isProfessor ? 'Измени термин' : 'Измени закажана консултација',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000066),
              ),
            ),
            const SizedBox(height: 24),
            if (widget.isProfessor) ...[
              _buildDateTimePickers(),
              const SizedBox(height: 16),
              _buildLocationField(),
            ],
            const SizedBox(height: 16),
            if (!widget.isProfessor) ...[
              _buildSubjectDropdown(),
              const SizedBox(height: 16),
              _buildReasonField(),
            ],
            const SizedBox(height: 16),
            _buildCommentField(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimePickers() {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Датум'),
          subtitle: Text(DateFormatter.formatDate(selectedDate)),
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 90)),
            );
            if (date != null) {
              setState(() => selectedDate = date);
            }
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Време'),
          subtitle: Text(selectedTime.format(context)),
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: selectedTime,
            );
            if (time != null) {
              setState(() => selectedTime = time);
            }
          },
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return TextField(
      controller: locationController,
      decoration: InputDecoration(
        labelText: 'Просторија',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildSubjectDropdown() {
    final subjects = ['Предмет 1', 'Предмет 2', 'Предмет 3'];
    return DropdownButtonFormField<String>(
      value: selectedSubject,
      decoration: InputDecoration(
        labelText: 'Предмет',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items: subjects.map((subject) {
        return DropdownMenuItem(value: subject, child: Text(subject));
      }).toList(),
      onChanged: (value) => setState(() => selectedSubject = value),
    );
  }

  Widget _buildReasonField() {
    return TextField(
      controller: reasonController,
      maxLines: 2,
      decoration: InputDecoration(
        labelText: 'Причина за консултација',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildCommentField() {
    return TextField(
      controller: commentController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Коментар',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Откажи'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0099FF),
            foregroundColor: Colors.white,
          ),
          child: const Text('Зачувај'),
        ),
      ],
    );
  }

  void _handleSave() {
    final DateTime newDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    Map<String, dynamic> result = {
      'dateTime': newDateTime,
      'location': locationController.text,
      'comment': commentController.text,
    };

    if (!widget.isProfessor) {
      result['subject'] = selectedSubject;
      result['reason'] = reasonController.text;
    }

    Navigator.pop(context, result);
  }
}
import 'package:flutter/material.dart';
import 'package:konsultacii/models/request/consultations_form_dto.dart';
import 'package:konsultacii/models/response/ConsultationsResponse.dart';
import 'package:konsultacii/services/manage_consultation_service.dart';
import '../../utils/date_formatter.dart';

class EditConsultationDialog extends StatefulWidget {
  final ConsultationResponse consultation;
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
  final ManageConsultationService _manageConsultationService =
      ManageConsultationService();

  late DateTime selectedDate;
  late TimeOfDay selectedTimeFrom;
  late TimeOfDay selectedTimeTo;
  late TextEditingController locationController;
  late TextEditingController commentController;
  late TextEditingController reasonController;
  bool? isOnline;
  late int id;
  String? selectedSubject;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.consultation.date;
    selectedTimeFrom = widget.consultation.startTime;
    selectedTimeTo = widget.consultation.endTime;
    locationController = TextEditingController(text: widget.consultation.room);
    commentController =
        TextEditingController(text: widget.consultation.studentInstruction);
    isOnline = widget.consultation.online ?? false;
    id = widget.consultation.id;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isProfessor
                  ? 'Измени термин'
                  : 'Измени закажана консултација',
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
            _buildStudentInstructionsField(),
            const SizedBox(height: 16),
            _buildOnlineCheckbox(),
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
          title: const Text('Време од'),
          subtitle: Text(selectedTimeFrom.format(context)),
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: selectedTimeFrom,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            );
            if (time != null) {
              setState(() => selectedTimeFrom = time);
            }
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Време до'),
          subtitle: Text(selectedTimeFrom.format(context)),
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: selectedTimeFrom,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            );
            if (time != null) {
              setState(() => selectedTimeTo = time);
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
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Color(0xFF0099FF),
              width: 2,
            ),
          ),
        ));
  }

  Widget _buildOnlineCheckbox() {
    return Row(
      children: [
        const Text(
          'Онлајн?',
          style: TextStyle(fontSize: 16),
        ),
        Checkbox(
          value: isOnline,
          onChanged: (bool? value) {
            setState(() {
              isOnline = value ?? false;
            });
          },
          activeColor: const Color(0xFF0099FF), // Match your theme color
        ),
      ],
    );
  }

  Widget _buildStudentInstructionsField() {
    return TextField(
      controller: commentController,
      maxLines: 3,
      enabled: widget.isProfessor,
      decoration: InputDecoration(
        labelText: 'Инструкции за студентите',
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
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
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
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0099FF),
            foregroundColor: Colors.white,
          ),
          child: const Text('Зачувај'),
        ),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    ConsultationFormDto result = new ConsultationFormDto(
        date: selectedDate,
        startTime: selectedTimeFrom,
        endTime: selectedTimeTo,
        roomName: locationController.text,
        studentInstructions: commentController.text,
        online: isOnline ?? false,);

    try {
      final updatedConsultation = await _manageConsultationService
          .editConsultation(id: id, consultationForm: result);

      if (mounted) {
        Navigator.pop(context, updatedConsultation);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}

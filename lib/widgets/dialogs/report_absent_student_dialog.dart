import 'package:flutter/material.dart';
import 'package:konsultacii/models/request/consultations_form_dto.dart';
import 'package:konsultacii/models/request/report_absent_student_request.dart';
import 'package:konsultacii/models/response/ConsultationsResponse.dart';
import 'package:konsultacii/models/response/consultation_attendance_response.dart';
import 'package:konsultacii/services/manage_consultation_service.dart';
import '../../models/consultation.dart';
import '../../services/ConsultationService.dart';
import '../../utils/date_formatter.dart';

class ReportAbsentStudentDialog extends StatefulWidget {
  final int attendanceId;

  const ReportAbsentStudentDialog({
    Key? key,
    required this.attendanceId,
  }) : super(key: key);

  @override
  _ReportAbsentStudentDialogState createState() =>
      _ReportAbsentStudentDialogState();
}

class _ReportAbsentStudentDialogState extends State<ReportAbsentStudentDialog> {

  late int attendanceId;
  late String studentName;
  late String studentIndex;
  late ConsultationResponse consultations;
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    attendanceId = widget.attendanceId;
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
            const Text(
              "Пријави отсутен студент",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000066),
              ),
            ),
            const SizedBox(height: 16),
            _buildStudentInstructionsField(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentInstructionsField() {
    return TextField(
      controller: commentController,
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
    ReportAbsentStudentRequest reportAbsentStudentRequest =
        new ReportAbsentStudentRequest(
            attendanceId: attendanceId, comment: commentController.text);

    try {
      if (mounted) {
        Navigator.pop(context, reportAbsentStudentRequest);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}

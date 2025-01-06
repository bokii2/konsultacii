import 'package:flutter/material.dart';
import 'package:konsultacii/models/request/report_absent_student_request.dart';
import 'package:konsultacii/models/response/ConsultationsResponse.dart';
import 'package:konsultacii/models/response/consultation_attendance_response.dart';
import 'package:konsultacii/services/consultation_attendance_service.dart';
import 'package:konsultacii/widgets/dialogs/report_absent_student_dialog.dart';
import '../../utils/date_formatter.dart';
import '../messaging_screen/messaging_screen.dart';

class ConsultationStudentsScreen extends StatefulWidget {
  final ConsultationResponse consultation;

  const ConsultationStudentsScreen({
    Key? key,
    required this.consultation,
  }) : super(key: key);

  @override
  State<ConsultationStudentsScreen> createState() =>
      _ConsultationStudentsScreenState();
}

class _ConsultationStudentsScreenState
    extends State<ConsultationStudentsScreen> {
  final ConsultationAttendanceService _attendanceService =
      ConsultationAttendanceService();
  bool _isLoading = true;
  List<ConsultationAttendanceResponse> _attendances = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAttendances();
  }

  Future<void> _loadAttendances() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final attendances = await _attendanceService.getAllAttendancesForSlot(
          id: widget.consultation.id);

      setState(() {
        _attendances = attendances;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load attendances: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0099FF),
        title: const Text(
          'Закажани студенти',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConsultationInfo(),
          Expanded(
            child: _buildStudentsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationInfo() {
    return SizedBox(
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormatter.formatDateTime(widget.consultation.date),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000066),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Просторија: ${widget.consultation.room}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              if (widget.consultation.studentInstruction.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Коментар: ${widget.consultation.studentInstruction}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ],
          ),
        ));
  }

  Widget _buildStudentsList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAttendances,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_attendances.isEmpty) {
      return const Center(
        child: Text('Нема закажани студенти'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAttendances,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _attendances.length,
        itemBuilder: (context, index) {
          final attendance = _attendances[index];
          return _buildStudentCard(
            attendanceId: attendance.id,
            studentName: attendance.studentName,
            studentIndex: attendance.studentIndex,
            professorDNA: attendance.reportAbsentProfessor ?? false,
            professorDNAComment: attendance.absentProfessorComment ?? '',
            studentDNA: attendance.reportAbsentStudent ?? false,
            studentDNAComment: attendance.absentStudentComment ?? '',
          );
        },
      ),
    );
  }

  Widget _buildStudentCard({
    required int attendanceId,
    required String studentName,
    required String studentIndex,
    required bool professorDNA,
    required bool studentDNA,
    required String professorDNAComment,
    required String studentDNAComment,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.book, color: Color(0xFF0099FF)),
                const SizedBox(width: 8),
                Text(
                  studentIndex,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _navigateToMessaging(context, attendanceId),
                  icon: const Icon(Icons.message),
                  color: Color(0xFF0099FF),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, color: Color(0xFF0099FF)),
                const SizedBox(width: 8),
                Text(
                  studentName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (!studentDNA)
                  IconButton(
                    onPressed: () =>
                        _showReportAbsenceDialog(context, attendanceId),
                    icon: const Icon(Icons.flag),
                    color: Colors.red,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showReportAbsenceDialog(
      BuildContext context, int attendanceId) async {
    final result = await showDialog<ReportAbsentStudentRequest>(
      context: context,
      builder: (context) => ReportAbsentStudentDialog(
        attendanceId: attendanceId,
      ),
    );

    if (result != null) {
      try {
        await _attendanceService.reportStudentAbsence(
            id: attendanceId, comment: result.comment);

        final index = _attendances.indexWhere((c) => c.id == attendanceId);
        if (index != -1) {
          _attendances[index] =
              _attendances[index].copyWith(reportAbsentStudent: true);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Отсуството е успешно запишано'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _navigateToMessaging(BuildContext context, int attendanceId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagingScreen(
          consultation: widget.consultation,
          attendanceId: attendanceId,
          isProfessor: true,
        ),
      ),
    );
  }
}

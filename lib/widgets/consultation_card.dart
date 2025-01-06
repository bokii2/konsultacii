// lib/widgets/consultation_card.dart
import 'package:flutter/material.dart';
import 'package:konsultacii/models/enum/ConsultationStatus.dart';
import 'package:konsultacii/models/response/ConsultationsResponse.dart';
import '../models/consultation.dart';
import '../screens/consultation_students/consultation_students_screen.dart';
import '../screens/messaging_screen/messaging_screen.dart';
import '../utils/date_formatter.dart';
import 'dialogs/edit_consultation_dialog.dart';
import 'dialogs/professor_availability_dialog.dart';

class ConsultationCard extends StatelessWidget {
  final ConsultationResponse consultation;
  final bool isProfessor;
  final VoidCallback? onDelete;
  final VoidCallback? onBook;
  final Function(ConsultationResponse)? onEdit;
  final VoidCallback? onMarkUnavailable;
  final VoidCallback? onCancel;

  const ConsultationCard({
    Key? key,
    required this.consultation,
    required this.isProfessor,
    this.onDelete,
    this.onBook,
    this.onEdit,
    this.onMarkUnavailable,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildDetails(),
              // if (consultation.bookingReason != null)
              //   _buildBookingDetails(),
              _buildActions(context),
            ],
          ),
        ));
  }

// In ConsultationCard
  Widget _buildStudentDetails() {
    if (!isProfessor || consultation.status != ConsultationStatus.ACTIVE) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF0099FF).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Закажано од:',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.person, size: 16, color: Color(0xFF0099FF)),
              SizedBox(width: 8),
              Text(
                '',
                // consultation.studentName ?? 'Непознат студент',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (consultation.studentInstruction != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.comment, size: 16, color: Color(0xFF0099FF)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    consultation.studentInstruction!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            consultation.professor,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF000066),
            ),
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  // In ConsultationCard
  Widget _buildStatusBadge() {
    Color statusColor;
    String statusText;

    switch (consultation.isCancelled) {
      case false:
        statusColor = const Color(0xFF4CAF50);
        statusText = 'Активен';
        break;
      case true:
        statusColor = Colors.red;
        statusText = 'Откажан';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Непознат';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            icon: Icons.event,
            label: 'Датум:',
            value: DateFormatter.formatDate(consultation.date),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.access_time,
            label: 'Време:',
            value:
                '${consultation.startTime.hour.toString().padLeft(2, '0')}:${consultation.startTime.minute.toString().padLeft(2, '0')} - ${consultation.endTime.hour.toString().padLeft(2, '0')}:${consultation.endTime.minute.toString().padLeft(2, '0')}',
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.location_on,
            label: 'Просторија:',
            value: consultation.room,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.timer,
            label: 'Online:',
            value: '${(consultation.online ?? false) ? "Да" : "Не"}',
          ),
          if (consultation.studentInstruction.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.comment,
              label: 'Дополнителни инструкции:',
              value: consultation.studentInstruction,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBookingDetails() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //   // if (consultation.studentName != null)
          //   //   _buildInfoRow(
          //   //     icon: Icons.person,
          //   //     label: 'Студент:',
          //   //     value: consultation.studentName!,
          //   //   ),
          //   // if (consultation.subject != null) ...[
          //   //   const SizedBox(height: 8),
          //   //   _buildInfoRow(
          //   //     icon: Icons.book,
          //   //     label: 'Предмет:',
          //   //     value: consultation.subject!,
          //   //   ),
          //   ],
          if (consultation.studentInstruction != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.info_outline,
              label: 'Причина:',
              value: consultation.studentInstruction,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (isProfessor) ...[
              if (consultation.status == ConsultationStatus.ACTIVE)
                ElevatedButton.icon(
                  icon: const Icon(Icons.people),
                  label: const Text('Студенти'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0099FF),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConsultationStudentsScreen(
                          consultation: consultation,
                        ),
                      ),
                    );
                  },
                ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF0099FF)),
                onPressed:
                    onEdit != null ? () => _showEditDialog(context) : null,
              ),
              IconButton(
                  icon: const Icon(Icons.cancel, color: Color(0xFF0099FF)),
                  onPressed: () => onMarkUnavailable!()),
            ] else ...[
              if (consultation.status == ConsultationStatus.ACTIVE)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0099FF),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: onBook,
                  child: const Text('Закажи'),
                ),
              if (consultation.status == ConsultationStatus.ACTIVE &&
                  true) // Replace with actual student ID
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: onCancel,
                ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildMessageButton(BuildContext context) {
    return TextButton.icon(
      icon: const Icon(
        Icons.message_outlined,
        color: Color(0xFF0099FF),
      ),
      label: const Text(
        'Порака',
        style: TextStyle(
          color: Color(0xFF0099FF),
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: () => _navigateToMessaging(context),
    );
  }

  Widget _buildProfessorActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (consultation.status == ConsultationStatus.ACTIVE) ...[
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF0099FF)),
            onPressed: () => _showEditDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.event_busy, color: Colors.orange),
            onPressed: () => onMarkUnavailable!(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
        if (consultation.status == ConsultationStatus.ACTIVE) ...[
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF0099FF)),
            onPressed: () => _showEditDialog(context),
          ),
        ],
      ],
    );
  }

  Widget _buildStudentActions(BuildContext context) {
    if (consultation.status == ConsultationStatus.ACTIVE && onBook != null) {
      return ElevatedButton.icon(
        icon: const Icon(Icons.calendar_month, size: 20),
        label: const Text('Закажи'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0099FF),
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onBook,
      );
    }

    if (consultation.status == ConsultationStatus.ACTIVE && true) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF0099FF)),
            onPressed: () => _showEditDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.cancel_outlined, color: Colors.red),
            onPressed: onCancel,
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToMessaging(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MessagingScreen(
          professorId: 'consultation.professorId',
          professorName: 'consultation.professorName',
          studentId: 'student1',
          studentName: 'Студент 1',
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final result = await showDialog<ConsultationResponse>(
      context: context,
      builder: (context) => EditConsultationDialog(
        consultation: consultation,
        isProfessor: isProfessor,
      ),
    );

    if (result != null && onEdit != null) {
      onEdit!(result);
    }
  }
}

// lib/widgets/consultation_card.dart
import 'package:flutter/material.dart';
import '../models/consultation.dart';
import '../screens/messaging_screen/messaging_screen.dart';
import '../utils/date_formatter.dart';
import 'dialogs/edit_consultation_dialog.dart';
import 'dialogs/professor_availability_dialog.dart';

class ConsultationCard extends StatelessWidget {
  final Consultation consultation;
  final bool isProfessor;
  final VoidCallback? onDelete;
  final VoidCallback? onBook;
  final Function(Map<String, dynamic>)? onEdit;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildDetails(),
          if (consultation.bookingReason != null)
            _buildBookingDetails(),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          consultation.professorName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000066),
          ),
        ),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color statusColor;
    String statusText;

    switch (consultation.status) {
      case ConsultationStatus.available:
        statusColor = const Color(0xFF4CAF50);
        statusText = 'Слободен';
        break;
      case ConsultationStatus.booked:
        statusColor = const Color(0xFF0099FF);
        statusText = 'Закажан';
        break;
      case ConsultationStatus.completed:
        statusColor = const Color(0xFF9E9E9E);
        statusText = 'Завршен';
        break;
      case ConsultationStatus.cancelled:
        statusColor = const Color(0xFFF44336);
        statusText = 'Откажан';
        break;
      case ConsultationStatus.professorUnavailable:
        statusColor = const Color(0xFFFF9800);
        statusText = 'Неслободен';
        break;
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
            value: DateFormatter.formatDate(consultation.dateTime),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.access_time,
            label: 'Време:',
            value: DateFormatter.formatTime(consultation.dateTime),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.location_on,
            label: 'Просторија:',
            value: consultation.location,
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            icon: Icons.timer,
            label: 'Времетраење:',
            value: '${consultation.durationMinutes} минути',
          ),
          if (consultation.comment.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.comment,
              label: 'Коментар:',
              value: consultation.comment,
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
          if (consultation.studentName != null)
            _buildInfoRow(
              icon: Icons.person,
              label: 'Студент:',
              value: consultation.studentName!,
            ),
          if (consultation.subject != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.book,
              label: 'Предмет:',
              value: consultation.subject!,
            ),
          ],
          if (consultation.bookingReason != null) ...[
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.info_outline,
              label: 'Причина:',
              value: consultation.bookingReason!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (consultation.status != ConsultationStatus.completed) ...[
            _buildMessageButton(context),
            const SizedBox(width: 8),
            if (isProfessor) ...[
              _buildProfessorActions(context),
            ] else ...[
              _buildStudentActions(context),
            ],
          ],
        ],
      ),
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
        if (consultation.status == ConsultationStatus.available) ...[
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF0099FF)),
            onPressed: () => _showEditDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.event_busy, color: Colors.orange),
            onPressed: () => _showMarkUnavailableDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
        if (consultation.status == ConsultationStatus.booked) ...[
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF0099FF)),
            onPressed: () => _showEditDialog(context),
          ),
        ],
      ],
    );
  }

  Widget _buildStudentActions(BuildContext context) {
    if (consultation.status == ConsultationStatus.available && onBook != null) {
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

    if (consultation.status == ConsultationStatus.booked &&
        consultation.studentId != null) {
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
          professorId: consultation.professorId,
          professorName: consultation.professorName,
          studentId: consultation.studentId ?? 'student1',
          studentName: consultation.studentName ?? 'Студент 1',
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
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

  Future<void> _showMarkUnavailableDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ProfessorAvailabilityDialog(
        consultation: consultation,
      ),
    );

    if (result == true && onMarkUnavailable != null) {
      onMarkUnavailable!();
    }
  }
}
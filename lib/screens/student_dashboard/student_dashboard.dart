// lib/screens/student/student_dashboard.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/consultation.dart';
import '../../widgets/consultation_card.dart';
import '../../widgets/dialogs/book_consultation_dialog.dart';
import '../../services/consultation_service.dart';
import '../../widgets/dialogs/edit_consultation_dialog.dart';
import '../../widgets/dialogs/professor_availability_dialog.dart';
class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final ConsultationService _consultationService = ConsultationService();
  List<Consultation> availableConsultations = [];
  String selectedProfessor = 'Сите';
  List<String> professors = ['Сите', 'Проф1', 'Проф2', 'Проф3'];
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? selectedSubject;
  List<String> subjects = ['Предмет 1', 'Предмет 2', 'Предмет 3'];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadConsultations();
  }

  void _loadConsultations() {
    availableConsultations = _consultationService.getAvailableConsultations(
      DateTime.now(),
      DateTime.now().add(const Duration(days: 30)),
      selectedProfessor == 'Сите' ? null : selectedProfessor,
      selectedSubject,
    );
    setState(() {});
  }

  List<Consultation> get filteredConsultations {
    return availableConsultations.where((consultation) {
      if (selectedProfessor != 'Сите' &&
          consultation.professorName != selectedProfessor) {
        return false;
      }
      return true;
    }).toList();
  }

  List<Consultation> _getConsultationsForDay(DateTime day) {
    return filteredConsultations.where((consultation) {
      return DateUtils.isSameDay(consultation.dateTime, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            _buildFilters(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCalendarView(),
                  _buildListView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF0099FF),
      title: const Text(
        'Консултации',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      bottom: TabBar(
        indicatorColor: Theme.of(context).colorScheme.inversePrimary,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        unselectedLabelColor: Colors.white70,
        indicatorWeight: 3,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        tabs: const [
          Tab(text: 'Календар'),
          Tab(text: 'Листа'),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.exit_to_app, color: Colors.white),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterDropdown(
              label: 'Изберете професор',
              value: selectedProfessor,
              items: professors,
              onChanged: (value) {
                setState(() {
                  selectedProfessor = value!;
                  _loadConsultations();
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildFilterDropdown(
              label: 'Изберете предмет',
              value: selectedSubject,
              items: subjects,
              onChanged: (value) {
                setState(() {
                  selectedSubject = value;
                  _loadConsultations();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
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
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              borderRadius: BorderRadius.circular(12),
              items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        _buildCalendar(),
        const Divider(height: 1),
        Expanded(
          child: _buildConsultationsForSelectedDay(),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 365)),
        lastDay: DateTime.now().add(const Duration(days: 365)),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        eventLoader: (day) => _getConsultationsForDay(day),
        locale: 'mk_MK',
        headerStyle: const HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          formatButtonTextStyle: TextStyle(fontSize: 14),
          formatButtonDecoration: BoxDecoration(
            color: Color(0xFF0099FF),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        calendarStyle: CalendarStyle(
          markersMaxCount: 3,
          markerSize: 8,
          markerDecoration: const BoxDecoration(
            color: Color(0xFF0099FF),
            shape: BoxShape.circle,
          ),
          selectedDecoration: const BoxDecoration(
            color: Color(0xFF0099FF),
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: const Color(0xFF0099FF).withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          weekendTextStyle: const TextStyle(color: Color(0xFF000066)),
          outsideTextStyle: TextStyle(color: Colors.grey[400]),
        ),
        availableCalendarFormats: const {
          CalendarFormat.month: 'Месец',
          CalendarFormat.twoWeeks: '2 Недели',
          CalendarFormat.week: 'Недела',
        },
      ),
    );
  }

  Widget _buildConsultationsForSelectedDay() {
    final consultationsForDay = _getConsultationsForDay(_selectedDay!);

    if (consultationsForDay.isEmpty) {
      return Center(
        child: Text(
          'Нема закажани консултации за избраниот ден',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      );
    }

    return _buildConsultationsList(consultationsForDay);
  }

  Widget _buildListView() {
    return _buildConsultationsList(filteredConsultations);
  }

  Widget _buildConsultationsList(List<Consultation> consultations) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: consultations.length,
      itemBuilder: (context, index) {
        final consultation = consultations[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ConsultationCard(
            consultation: consultation,
            isProfessor: false,
            onBook: consultation.status == ConsultationStatus.available
                ? () => _handleBookConsultation(consultation)
                : null,
            onCancel: consultation.status == ConsultationStatus.booked &&
                consultation.studentId == 'student1' // Replace with actual student ID
                ? () => _handleCancelConsultation(consultation)
                : null,
            onEdit: consultation.status == ConsultationStatus.booked &&
                consultation.studentId == 'student1' // Replace with actual student ID
                ? (updates) => _handleEditConsultation(consultation, updates)
                : null,
          ),
        );
      },
    );
  }
  void _handleBookConsultation(Consultation consultation) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => BookConsultationDialog(
        consultation: consultation,
      ),
    );

    if (result != null) {
      setState(() {
        _consultationService.updateConsultation(consultation.id, {
          'studentId': 'student1', // Replace with actual student ID
          'studentName': 'Студент 1', // Replace with actual student name
          'subject': result['subject'],
          'reason': result['reason'],
          'status': ConsultationStatus.booked,
        });
        _loadConsultations();
      });
      _showBookingConfirmation();
    }
  }

  void _handleCancelConsultation(Consultation consultation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Откажи консултација'),
        content: const Text('Дали сте сигурни дека сакате да ја откажете консултацијата?'),
        actions: [
          TextButton(
            child: const Text('Не'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Да'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _consultationService.updateConsultation(
          consultation.id,
          {'status': ConsultationStatus.available},
        );
        _loadConsultations();
      });
      _showCancelConfirmation();
    }
  }

  void _handleEditConsultation(Consultation consultation, Map<String, dynamic> updates) {
    setState(() {
      _consultationService.updateConsultation(consultation.id, updates);
      _loadConsultations();
    });
  }

  void _showCancelConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Консултацијата е успешно откажана'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showBookingConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Консултациите се успешно закажани!'),
        backgroundColor: const Color(0xFF0099FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
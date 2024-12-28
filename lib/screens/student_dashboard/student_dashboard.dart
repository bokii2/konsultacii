// lib/screens/student/student_dashboard.dart
import 'package:flutter/material.dart';
import 'package:konsultacii/models/response/ConsultationsResponse.dart';
import 'package:konsultacii/models/response/professor_response.dart';
import 'package:konsultacii/services/ConsultationService.dart';
import 'package:konsultacii/services/professor_service.dart';

import 'package:table_calendar/table_calendar.dart';
import '../../widgets/consultation_card.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  final ConsultationService _consultationService = ConsultationService();
  final ProfessorService _professorService = ProfessorService();
  List<ConsultationResponse> consultations = [];
  List<DateTime> daysWithConsultations = [];
  bool _isLoadingDayEvents = false;
  String? _error;

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String? selectedProfessor;
  List<ProfessorResponse> professors = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadDaysWithEvents();
    _loadProfessors();
  }

  Future<void> _loadEventsForDay(DateTime day) async {
    if (_isLoadingDayEvents) return;

    setState(() {
      _isLoadingDayEvents = true;
    });

    try {
      final events = await _consultationService
          .getAllConsultationsByDateAndProfessorId(day, selectedProfessor);
      setState(() {
        consultations = events;
      });
    } catch (e) {
      print('Error loading events for day: $e');
    } finally {
      setState(() {
        _isLoadingDayEvents = false;
      });
    }
  }

  Future<void> _loadDaysWithEvents() async {
    try {
      final response =
          await _consultationService.getDaysOfUpcomingConsultations();
      setState(() {
        daysWithConsultations = response;
      });
    } catch (e) {
      print('Error loading days with events: $e');
    }
  }

  List<int> _getEventsForDay(DateTime day) {
    if (daysWithConsultations.contains(DateUtils.dateOnly(day))) {
      return [1];
    }
    return [];
  }

  List<ConsultationResponse> _getConsultationsForDay(DateTime day) {
    if (consultations.isEmpty) {
      return [];
    }
    return consultations.where((consultation) {
      return DateUtils.isSameDay(consultation.date, day);
    }).toList();
  }

  Future<void> _loadProfessors() async {
    try {
      final response = await _professorService.getProfessors();
      setState(() {
        professors =
            response; // Ensure `professors` is a list variable in your state.
      });
    } catch (e) {
      print('Error loading professors: $e');
    }
  }

  List<ConsultationResponse> get filteredConsultations {
    return consultations.where((consultation) {
      if (selectedProfessor != null &&
          consultation.professor != selectedProfessor) {
        return false;
      }
      return true;
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
                  selectedProfessor = value;
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
    required List<ProfessorResponse> items,
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
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text(
                    "Сите професори",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
                ...items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item.username,
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
              ],
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
        if (_selectedDay != null) ...[
          const SizedBox(height: 20),
          _isLoadingDayEvents
              ? const Expanded(
            child: Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth:
                  4,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(
                      0xFF0099FF)), // Optional: match your theme color
                ),
              ),
            ),
          )
              : Expanded(
            child: _buildConsultationsForSelectedDay(),
          ),
        ],
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
        selectedDayPredicate: (day) =>
        _selectedDay != null && isSameDay(_selectedDay!, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });

          _loadEventsForDay(selectedDay);
        },
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        eventLoader: (day) => _getEventsForDay(day),
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
        ),
        locale: 'mk_MK',
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildConsultationsForSelectedDay() {
    if (_selectedDay == null) {
      return const Center(
        child: Text(
          'Изберете ден за да ги видите консултациите',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: consultationsForDay.length,
      itemBuilder: (context, index) {
        if (index >= consultationsForDay.length) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ConsultationCard(
            consultation: consultationsForDay[index],
            isProfessor: false,
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    if (consultations.isEmpty) {
    // if (filteredConsultations.isEmpty) {
      return const Center(
        child: Text(
          'Нема закажани консултации',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: consultations.length,
      itemBuilder: (context, index) {
        if (index >= consultations.length) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ConsultationCard(
            consultation: consultations[index],
            isProfessor: false,
          ),
        );
      },
    );
  }

  // Widget _buildConsultationsList(List<ConsultationResponse> consultations) {
  //   return ListView.builder(
  //     padding: const EdgeInsets.all(16),
  //     itemCount: consultations.length,
  //     itemBuilder: (context, index) {
  //       final consultation = consultations[index];
  //       return Padding(
  //         padding: const EdgeInsets.only(bottom: 12),
  //         child: ConsultationCard(
  //           consultation: consultation,
  //           isProfessor: false,
  //           onBook: consultation.status == ConsultationStatus.ACTIVE
  //               ? () => _handleBookConsultation(consultation)
  //               : null,
  //           onCancel: consultation.status == ConsultationStatus.ACTIVE && true
  //               // consultation.studentId == 'student1' // Replace with actual student ID
  //               ? () => _handleCancelConsultation(consultation)
  //               : null,
  //           onEdit: consultation.status == ConsultationStatus.ACTIVE && true
  //               // consultation.studentId == 'student1' // Replace with actual student ID
  //               ? (updates) => _handleEditConsultation(consultation, updates)
  //               : null,
  //         ),
  //       );
  //     },
  //   );
  // }

  // void _handleBookConsultation(ConsultationResponse consultation) async {
  //   final result = await showDialog<Map<String, dynamic>>(
  //     context: context,
  //     builder: (context) => BookConsultationDialog(
  //       consultation: consultation,
  //     ),
  //   );
  //
  //   if (result != null) {
  //     final bookingDetails = {
  //       'studentId': 'student1',
  //       'studentName': 'Студент 1',
  //       'subject': result['subject'],
  //       'reason': result['reason'],
  //       'status': ConsultationStatus.ACTIVE,
  //     };
  //
  //     setState(() {
  //       // _consultationService.updateConsultation(consultation.id, bookingDetails);
  //       // consultation.status = ConsultationStatus.ACTIVE;
  //       // Refresh the list
  //       _loadConsultations();
  //     });
  //
  //     // Show success message
  //     _showBookingConfirmation();
  //   }
  // }

  // void _handleCancelConsultation(ConsultationResponse consultation) async {
  //   final confirmed = await showDialog<bool>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Откажи консултација'),
  //       content: const Text('Дали сте сигурни дека сакате да ја откажете консултацијата?'),
  //       actions: [
  //         TextButton(
  //           child: const Text('Не'),
  //           onPressed: () => Navigator.pop(context, false),
  //         ),
  //         ElevatedButton(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.red,
  //             foregroundColor: Colors.white,
  //           ),
  //           child: const Text('Да'),
  //           onPressed: () => Navigator.pop(context, true),
  //         ),
  //       ],
  //     ),
  //   );
  //
  //   if (confirmed == true) {
  //     setState(() {
  //       // _consultationService.updateConsultation(
  //       //   consultation.id,
  //       //   {'status': ConsultationStatus.available},
  //       // );
  //       _loadConsultations();
  //     });
  //     _showCancelConfirmation();
  //   }
  // }

  // void _handleEditConsultation(ConsultationResponse consultation, ConsultationResponse updatedConsultation) {
  //   setState(() {
  //     // _consultationService.updateConsultation(consultation.id, updates);
  //     _loadConsultations();
  //   });
  // }

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

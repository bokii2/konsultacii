// lib/screens/student/student_dashboard.dart
import 'package:flutter/material.dart';
import 'package:konsultacii/main.dart';
import 'package:konsultacii/models/request/schedule_consultation_request.dart';
import 'package:konsultacii/models/response/ConsultationsResponse.dart';
import 'package:konsultacii/models/response/professor_response.dart';
import 'package:konsultacii/services/ConsultationService.dart';
import 'package:konsultacii/services/professor_service.dart';

import 'package:table_calendar/table_calendar.dart';
import '../../widgets/consultation_card.dart';
import '../../widgets/dialogs/book_consultation_confirm_dialog.dart';
import '../../widgets/dialogs/cancel_consultation_confrim_dialog.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with SingleTickerProviderStateMixin {
  final ConsultationService _consultationService = ConsultationService();
  final ProfessorService _professorService = ProfessorService();
  late TabController _tabController;
  List<ConsultationResponse> consultations = [];
  List<DateTime> daysWithConsultations = [];
  bool _isLoadingDayEvents = false;

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String? selectedProfessor;
  List<ProfessorResponse> professors = [];
  bool isFirstTabActive = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadDaysWithEvents();
    _loadProfessors();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      // Listen for tab changes and rebuild UI
      setState(() {
        isFirstTabActive = _tabController.index == 0;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
      SnackBarService.showSnackBar('Грешка при вчитување на термините',
          isError: true);
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
      SnackBarService.showSnackBar('Грешка при вчитување на термините',
          isError: true);
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
        professors = response;
      });
    } catch (e) {
      SnackBarService.showSnackBar('Грешка при вчитување на професорите',
          isError: true);
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
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              _buildSliverAppBar(context),
              SliverToBoxAdapter(
                child: _buildFilters(),
              ),
              if (_tabController.index == 0) ...[
                PinnedHeaderSliver(
                  child: _buildCalendar(),
                )
              ],
              const SliverToBoxAdapter(
                child: Divider(height: 1),
              ),
            ];
          },
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildCalendarView(),
              _buildListView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      title: const Text("Консултации"),
      pinned: true,
      floating: true,
      bottom: TabBar(
        controller: _tabController,
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
                if (_selectedDay != null) {
                  _loadEventsForDay(_selectedDay!);
                }
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
                        strokeWidth: 4,
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
          'Нема закажани консултации',
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
            onBook: () => _handleBookConsultation(consultationsForDay[index]),
            onCancel: () =>
                _handleCancelConsultation(consultationsForDay[index]),
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    // if (consultations.isEmpty) {
    if (filteredConsultations.isEmpty) {
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
      itemCount: filteredConsultations.length,
      itemBuilder: (context, index) {
        if (index >= filteredConsultations.length) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ConsultationCard(
            consultation: filteredConsultations[index],
            isProfessor: false,
            onBook: () => _handleBookConsultation(filteredConsultations[index]),
            onCancel: () =>
                _handleCancelConsultation(filteredConsultations[index]),
          ),
        );
      },
    );
  }

  Future<void> _handleBookConsultation(
      ConsultationResponse consultation) async {
    final confirmed = await showDialog<ScheduleConsultationRequest>(
      context: context,
      builder: (context) => BookConsultationConfirmDialog(
        consultation: consultation,
      ),
    );

    if (confirmed != null) {
      try {
        await _consultationService.scheduleConsultations(confirmed);

        SnackBarService.showSnackBar('Присуството е успешно закажано');

        setState(() {
          final index =
              consultations.indexWhere((c) => c.id == consultation.id);
          if (index != -1) {
            consultations[index] =
                consultations[index].copyWith(isBooked: true);
          }
        });
      } catch (e) {
        print(e);
        SnackBarService.showSnackBar('Грешка при закажување на присуството',
            isError: true);
      }
    }
  }

  Future<void> _handleCancelConsultation(
      ConsultationResponse consultation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) =>
          CancelConsultationDialog(consultation: consultation),
    );

    if (confirmed == true) {
      try {
        await _consultationService.cancelConsultations(consultation.id);

        SnackBarService.showSnackBar('Присуството е успешно откажано');

        setState(() {
          final index =
              consultations.indexWhere((c) => c.id == consultation.id);
          if (index != -1) {
            consultations[index] =
                consultations[index].copyWith(isBooked: false);
          }
        });
      } catch (e) {
        SnackBarService.showSnackBar('Грешка при откажување на присуството',
            isError: true);
      }
    }
  }
}

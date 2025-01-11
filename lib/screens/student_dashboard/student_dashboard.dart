// lib/screens/student/student_dashboard.dart
// import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:konsultacii/main.dart';
import 'package:konsultacii/models/request/schedule_consultation_request.dart';
import 'package:konsultacii/models/response/ConsultationsResponse.dart';
import 'package:konsultacii/models/response/professor_response.dart';
import 'package:konsultacii/services/calendar_utils_service.dart';
import 'package:konsultacii/services/consultation_service.dart';
import 'package:konsultacii/services/professor_service.dart';
import 'package:marquee/marquee.dart';

import 'package:table_calendar/table_calendar.dart';
import '../../widgets/consultation_card.dart';
import '../../widgets/dialogs/book_consultation_confirm_dialog.dart';
import '../../widgets/dialogs/cancel_consultation_confrim_dialog.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard>
    with SingleTickerProviderStateMixin {
  final ConsultationService _consultationService = ConsultationService();
  final ProfessorService _professorService = ProfessorService();
  final CalendarUtilsService _calendarUtilsService = CalendarUtilsService();
  late TabController _tabController;
  List<ConsultationResponse> consultations = [];
  List<ConsultationResponse> consultationsList = [];
  List<ConsultationResponse> myConsultations = [];
  List<DateTime> daysWithConsultations = [];
  bool _isLoadingDayEvents = false;
  bool _isLoadingListEvents = false;
  bool _isLoadingMyConsultations = false;

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String? selectedProfessor;
  List<ProfessorResponse> professors = [];
  bool isFirstTabActive = false;
  int activeTab = 0;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadDaysWithEvents();
    _loadProfessors();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        isFirstTabActive = _tabController.index == 0;
        activeTab = _tabController.index;
        if (_tabController.index == 1) {
          consultationsList = [];
          _loadListEvents();
        } else if (_tabController.index == 2) {
          myConsultations = [];
          consultationsList = [];
          _loadMyConsultations();
        }
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

  Future<void> _loadListEvents() async {
    if (_isLoadingListEvents) return;

    setState(() {
      _isLoadingListEvents = true;
    });

    try {
      final events = await _consultationService
          .getAllConsultationsByDateAndProfessorId(null, selectedProfessor);
      setState(() {
        consultationsList = events;
      });
    } catch (e) {
      SnackBarService.showSnackBar('Грешка при вчитување на термините',
          isError: true);
    } finally {
      setState(() {
        _isLoadingListEvents = false;
      });
    }
  }

  Future<void> _loadMyConsultations() async {
    if (_isLoadingMyConsultations) return;

    setState(() {
      _isLoadingMyConsultations = true;
    });

    try {
      final events = await _consultationService
          .getMyConsultationsByProfessorId(selectedProfessor);
      setState(() {
        myConsultations = events;
      });
    } catch (e) {
      SnackBarService.showSnackBar('Грешка при вчитување на термините',
          isError: true);
    } finally {
      setState(() {
        _isLoadingMyConsultations = false;
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
    return Scaffold(
      // Remove DefaultTabController
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
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildCalendarView(),
            _buildListView(_isLoadingListEvents, consultationsList),
            _buildListView(_isLoadingMyConsultations, myConsultations),
          ],
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
          Tab(
            icon: Icon(Icons.calendar_today),
          ),
          Tab(
            icon: Icon(Icons.list),
          ),
          Tab(
            icon: Icon(Icons.perm_contact_calendar),
          ),
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
                if (_selectedDay != null && _tabController.index == 0) {
                  _loadEventsForDay(_selectedDay!);
                  consultationsList = [];
                }
                if (_tabController.index == 1) {
                  _loadListEvents();
                }
                if (_tabController.index == 2) {
                  _loadMyConsultations();
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
                }),
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

  Widget _buildListView(
      bool isLoading, List<ConsultationResponse> consultationsList) {
    if (isLoading) {
      return const Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0099FF)),
          ),
        ),
      );
    }

    if (consultationsList.isEmpty) {
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
      itemCount: consultationsList.length,
      itemBuilder: (context, index) {
        if (index >= consultationsList.length) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ConsultationCard(
            consultation: consultationsList[index],
            isProfessor: false,
            onBook: () => _handleBookConsultation(consultationsList[index]),
            onCancel: () => _handleCancelConsultation(consultationsList[index]),
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

        final date = consultation.date;
        final startTime = consultation.startTime;
        final endTime = consultation.endTime;

        await _calendarUtilsService.addEventToCalendar(
            'Консултации',
            'Консултации кај ${consultation.professor}',
            consultation.online ?? false ? 'Online' : consultation.room,
            TZDateTime(tz.local, date.year, date.month, date.day,
                startTime.hour - 1, startTime.minute),
            TZDateTime(tz.local, date.year, date.month, date.day,
                endTime.hour - 1, endTime.minute),
            60);

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
        await _calendarUtilsService.deleteEventFromCalendar(
            consultation.date, consultation.professor);
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
        print(e);
        SnackBarService.showSnackBar('Грешка при откажување на присуството',
            isError: true);
      }
    }
  }
}

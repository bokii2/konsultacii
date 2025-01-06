// lib/screens/professor/professor_dashboard.dart
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:konsultacii/models/enum/ConsultationStatus.dart';
import 'package:konsultacii/models/request/irregular_consultations_request.dart';
import 'package:konsultacii/services/consultation_service.dart';
import 'package:konsultacii/services/manage_consultation_service.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../main.dart';
import '../../models/consultation.dart';
import '../../models/response/ConsultationsResponse.dart';
import '../../widgets/consultation_card.dart';
import '../../utils/date_formatter.dart';
import '../../widgets/dialogs/add_single_consultation_slot.dart';
import '../../widgets/dialogs/professor_availability_dialog.dart';

class ProfessorDashboard extends StatefulWidget {
  const ProfessorDashboard({Key? key}) : super(key: key);

  @override
  _ProfessorDashboardState createState() => _ProfessorDashboardState();
}

class _ProfessorDashboardState extends State<ProfessorDashboard> {
  final ConsultationService _consultationService = ConsultationService();
  final ManageConsultationService _manageConsultationService = ManageConsultationService();
  List<ConsultationResponse> consultations = [];
  List<DateTime> daysWithConsultations = [];
  bool _isLoading = false;
  bool _isLoadingDayEvents = false;
  String? _error;

  // List<Consultation> consultations = [];
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadDaysWithEvents();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.clearSnackBars();

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          left: 16,
          right: 16,
        ),
      ),
    );
  }

  Future<void> _loadEventsForDay(DateTime day) async {
    if (_isLoadingDayEvents) return;

    setState(() {
      _isLoadingDayEvents = true;
    });

    try {
      final events = await _consultationService
          .getAllConsultationsByDateAndProfessorId(day, null);
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

  void _handleEditConsultation(ConsultationResponse consultation,
      ConsultationResponse updatedConsultation) {
    setState(() {
      // _consultationService.updateConsultation(consultation.id, updates);

      final index = consultations.indexWhere((c) => c.id == consultation.id);
      if (index != -1) {
        consultations[index] = updatedConsultation;
      }
      //
      // if (updates.containsKey('dateTime')) {
      //   _selectedDay = updates['dateTime'] as DateTime;
      //   _focusedDay = updates['dateTime'] as DateTime;
      // }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Консултацијата е успешно изменета'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: TabBarView(
            children: [
              _buildCalendarView(),
              _buildListView(),
              const SizedBox(height: 100)
            ],
          ),
          floatingActionButton: _buildFloatingActionButton(),
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
        indicatorWeight: 3,
        indicatorColor: Theme.of(context).colorScheme.inversePrimary,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        unselectedLabelColor: Colors.white70,
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
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0099FF)),
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
      return Container(
        alignment: Alignment.center,
        child: Text(
          'Нема закажани консултации',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      );
    }

    final consultationsForDay = _getConsultationsForDay(_selectedDay!);

    if (consultationsForDay.isEmpty) {
      return ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Нема закажани консултации',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: consultationsForDay.length + 1,
      itemBuilder: (context, index) {
        if (index == consultationsForDay.length) {
          return const SizedBox(height: 80); // Space for FAB
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ConsultationCard(
            consultation: consultationsForDay[index],
            isProfessor: true,
            onDelete: () => _showDeleteConfirmation(consultationsForDay[index]),
            onEdit: (updates) =>
                _handleEditConsultation(consultationsForDay[index], updates),
            onMarkUnavailable: () =>
                _showMarkUnavailableConfirmation(consultationsForDay[index]),
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    if (consultations.isEmpty) {
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
      itemCount: consultations.length + 1, // Add 1 for the extra space item
      itemBuilder: (context, index) {
        if (index == consultations.length) {
          return const SizedBox(height: 80); // Space for FAB
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ConsultationCard(
            consultation: consultations[index],
            isProfessor: true,
            onDelete: () => _showDeleteConfirmation(consultations[index]),
            onEdit: (updates) =>
                _handleEditConsultation(consultations[index], updates),
            onMarkUnavailable: () =>
                _showMarkUnavailableConfirmation(consultations[index]),
          ),
        );
      },
    );
  }

  Future<void> _showMarkUnavailableConfirmation(
      ConsultationResponse consultation) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ProfessorCancelConsultationDialog(
        consultation: consultation,
      ),
    );

    if (result == true) {
      await _manageConsultationService.deleteConsultation(id: consultation.id);

      setState(() {
        consultations.removeWhere((c) => c.id == consultation.id);
      });

      SnackBarService.showSnackBar('Консултациите се успешно откажани');

    }
  }

  Future<void> _showDeleteConfirmation(
      ConsultationResponse consultation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Избриши консултација',
            style: TextStyle(
              color: Color(0xFF000066),
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
              'Дали сте сигурни дека сакате да ја избришете консултацијата закажана за '
              '${DateFormatter.formatDateTime(consultation.date)}?'),
          actions: [
            TextButton(
              child: Text(
                'Откажи',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () => Navigator.pop(context, false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Избриши'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        // _consultationService.deleteConsultation(consultatconst ion.id);
        consultations.remove(consultation);
      });
    }
  }

  Widget _buildFloatingActionButton() {
    return CircularMenu(
      alignment: Alignment.bottomRight,
      toggleButtonColor: const Color(0xFF0099FF),
      toggleButtonIconColor: Colors.white,
      toggleButtonSize: 36.0,
      toggleButtonAnimatedIconData: AnimatedIcons.menu_close,
      toggleButtonBoxShadow: const [],
      items: [
        CircularMenuItem(
          icon: Icons.add,
          color: const Color(0xFF0099FF),
          iconColor: Colors.white,
          boxShadow: const [],
          onTap: () {
            _showAddConsultationDialog(context);
          },
        ),
        CircularMenuItem(
          icon: Icons.playlist_add,
          color: const Color(0xFF0099FF),
          iconColor: Colors.white,
          boxShadow: [],
          onTap: () {
            _showAddConsultationDialog(context);
          },
        ),
      ],
    );
  }

  Future<void> _showAddConsultationDialog(BuildContext context) async {
    final IrregularConsultationsRequest? result = await showDialog<IrregularConsultationsRequest>(
      context: context,
      builder: (BuildContext context) => const AddConsultationDialog(),
    );

    if (result != null) {
      await _manageConsultationService.createIrregularConsultations(professorId: 'riste.stojanov', request: result);

      _loadDaysWithEvents();
      _loadEventsForDay(_focusedDay);


      SnackBarService.showSnackBar('Консултациите се успшено додадени');
    }
  }
}

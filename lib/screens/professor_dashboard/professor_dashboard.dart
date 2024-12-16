// lib/screens/professor/professor_dashboard.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/consultation.dart';
import '../../widgets/consultation_card.dart';
import '../../utils/date_formatter.dart';
import '../../services/consultation_service.dart';
import '../../utils/consultation_helper.dart';
import '../../widgets/dialogs/edit_consultation_dialog.dart';
import '../../widgets/dialogs/professor_availability_dialog.dart';
class ProfessorDashboard extends StatefulWidget {
  const ProfessorDashboard({Key? key}) : super(key: key);

  @override
  _ProfessorDashboardState createState() => _ProfessorDashboardState();
}

class _ProfessorDashboardState extends State<ProfessorDashboard> {
  final ConsultationService _consultationService = ConsultationService();
  List<Consultation> consultations = [];
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadConsultations();
  }

  void _loadConsultations() {
    consultations = _consultationService.getConsultationsForProfessor('prof1');
    setState(() {});
  }

  List<Consultation> _getConsultationsForDay(DateTime day) {
    if (consultations.isEmpty) {
      return [];
    }
    return consultations.where((consultation) {
      if (consultation.dateTime == null) return false;
      return DateUtils.isSameDay(consultation.dateTime, day);
    }).toList();
  }

  void _handleEditConsultation(Consultation consultation, Map<String, dynamic> updates) {
    setState(() {
      if (updates.containsKey('dateTime')) {
        consultation.updateDetails(
          newDateTime: updates['dateTime'] as DateTime,
          newLocation: updates['location'] as String?,
          newComment: updates['comment'] as String?,
        );
      }

      _consultationService.updateConsultation(consultation.id, updates);

      // Update in local list
      final index = consultations.indexWhere((c) => c.id == consultation.id);
      if (index != -1) {
        consultations[index] = consultation;
      }

      // Update selected day if date changed
      if (updates.containsKey('dateTime')) {
        _selectedDay = updates['dateTime'] as DateTime;
        _focusedDay = updates['dateTime'] as DateTime;
      }
    });

    // Show success message
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: TabBarView(
          children: [
            _buildCalendarView(),
            _buildListView(),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(),
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
        selectedDayPredicate: (day) =>
        _selectedDay != null && isSameDay(_selectedDay!, day),
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
            isProfessor: true,
            onDelete: () => _showDeleteConfirmation(consultationsForDay[index]),
            onEdit: (updates) => _handleEditConsultation(consultationsForDay[index], updates),
            onMarkUnavailable: () => _showMarkUnavailableConfirmation(consultationsForDay[index]),
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
      itemCount: consultations.length,
      itemBuilder: (context, index) {
        if (index >= consultations.length) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ConsultationCard(
            consultation: consultations[index],
            isProfessor: true,
            onDelete: () => _showDeleteConfirmation(consultations[index]),
            onEdit: (updates) => _handleEditConsultation(consultations[index], updates),
            onMarkUnavailable: () => _showMarkUnavailableConfirmation(consultations[index]),
          ),
        );
      },
    );
  }
  Future<void> _showMarkUnavailableConfirmation(Consultation consultation) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ProfessorAvailabilityDialog(
        consultation: consultation,
      ),
    );

    if (result == true) {
      setState(() {
        consultation.status = ConsultationStatus.professorUnavailable;
        _consultationService.updateConsultation(
          consultation.id,
          {'status': ConsultationStatus.professorUnavailable},
        );
        // Refresh the list to reflect changes
        final index = consultations.indexWhere((c) => c.id == consultation.id);
        if (index != -1) {
          consultations[index] = consultation;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Терминот е означен како неслободен'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }
  Future<void> _showDeleteConfirmation(Consultation consultation) async {
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
                  '${DateFormatter.formatDateTime(consultation.dateTime)}?'
          ),
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
        _consultationService.deleteConsultation(consultation.id);
        consultations.remove(consultation);
      });
    }
  }
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF0099FF),
      elevation: 4,
      onPressed: () => _showAddConsultationDialog(context),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _showAddConsultationDialog(BuildContext context) {
    // Create state variables
    late DateTime selectedDate;
    late TimeOfDay selectedTime;
    late String location;
    late String comment;

    // Initialize state
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    location = '';
    comment = '';

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {  // Renamed setState to setDialogState for clarity
            return AlertDialog(
              title: const Text(
                'Додади термин',
                style: TextStyle(
                  color: Color(0xFF000066),
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF0099FF),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      },
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Час'),
                      subtitle: Text(selectedTime.format(context)),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF0099FF),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (time != null) {
                          setState(() {
                            selectedTime = time;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Просторија',
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
                      ),
                      onChanged: (value) => location = value,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Дополнителен коментар',
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
                      ),
                      onChanged: (value) => comment = value,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Откажи',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0099FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Додади'),
                  onPressed: () {
                    if (location.isNotEmpty) {
                      // Create the new consultation
                      final newConsultation = Consultation(
                        id: DateTime.now().toString(),
                        professorId: 'prof1',
                        professorName: 'Проф1',
                        dateTime: DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                        ),
                        durationMinutes: 30,
                        location: location,
                        comment: comment,
                        status: ConsultationStatus.available,
                      );

                      // Add to service and update parent state
                      _consultationService.addConsultation(newConsultation);

                      // Use the parent's setState to update the main screen
                      setState(() {  // This refers to the parent widget's setState
                        consultations.add(newConsultation);
                        _selectedDay = newConsultation.dateTime;
                        _focusedDay = newConsultation.dateTime;
                      });

                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Консултацијата е успешно додадена'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(16),
                        ),
                      );

                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      // This will run after the dialog is closed
      setState(() {
        // Force refresh the view
        consultations = List.from(consultations);
      });
    });
  }
}
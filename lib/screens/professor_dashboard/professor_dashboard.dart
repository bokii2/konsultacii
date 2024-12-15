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
    // Replace with your actual professor ID
    consultations = _consultationService.getConsultationsForProfessor('prof1');
    setState(() {});
  }

  List<Consultation> _getConsultationsForDay(DateTime day) {
    return consultations.where((consultation) {
      return DateUtils.isSameDay(consultation.dateTime, day);
    }).toList();
  }
  void _handleDeleteConsultation(Consultation consultation) {
    setState(() {
      _consultationService.deleteConsultation(consultation.id);
      consultations.remove(consultation);
    });
  }

  void _handleEditConsultation(Consultation consultation, Map<String, dynamic> updates) {
    setState(() {
      _consultationService.updateConsultation(consultation.id, updates);
      _loadConsultations(); // Reload to get updated data
    });
  }

  void _handleMarkUnavailable(Consultation consultation) {
    setState(() {
      _consultationService.updateConsultation(
        consultation.id,
        {'status': ConsultationStatus.professorUnavailable},
      );
      _loadConsultations();
    });
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
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ConsultationCard(
            consultation: consultationsForDay[index],
            isProfessor: true,
            onDelete: () => _handleDeleteConsultation(consultationsForDay[index]),
            onEdit: (updates) => _handleEditConsultation(consultationsForDay[index], updates),
            onMarkUnavailable: () => _handleMarkUnavailable(consultationsForDay[index]),
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    final consultationsForDay = _getConsultationsForDay(_selectedDay!);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: consultations.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ConsultationCard(
            consultation: consultationsForDay[index],
            isProfessor: true,
            onDelete: () => _handleDeleteConsultation(consultationsForDay[index]),
            onEdit: (updates) => _handleEditConsultation(consultationsForDay[index], updates),
            onMarkUnavailable: () => _handleMarkUnavailable(consultationsForDay[index]),
          ),
        );
      },
    );
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
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();
    String location = '';
    String comment = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              _buildDialogListTile(
                title: 'Датум',
                subtitle: DateFormatter.formatDate(selectedDate),
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
                  if (date != null) selectedDate = date;
                },
              ),
              _buildDialogListTile(
                title: 'Час',
                subtitle: selectedTime.format(context),
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
                  if (time != null) selectedTime = time;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Просторија',
                onChanged: (value) => location = value,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Дополнителен коментар',
                onChanged: (value) => comment = value,
                maxLines: 3,
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

                setState(() {
                  _consultationService.addConsultation(newConsultation);
                  _loadConsultations();
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDialogListTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.grey[700],
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildTextField({
    required String label,
    required ValueChanged<String> onChanged,
    int maxLines = 1,
  }) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: maxLines > 1,
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
      onChanged: onChanged,
    );
  }
}
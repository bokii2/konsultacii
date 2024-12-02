import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const ConsultationApp());
}

// Models
class Consultation {
  final String id;
  final String professorId;
  final String professorName;
  final DateTime dateTime;
  final int durationMinutes;
  final String location;
  final String? studentId;
  late final String status; // 'available', 'booked', 'completed'
  final String comment;

  Consultation(
      {required this.id,
      required this.professorId,
      required this.professorName,
      required this.dateTime,
      required this.durationMinutes,
      required this.location,
      this.studentId,
      this.status = 'available',
      this.comment = ""});
}

class ConsultationApp extends StatelessWidget {
  const ConsultationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consultation Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const RoleSelectionScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('mk', 'MK'),
        Locale('en', 'US'),
      ],
    );
  }
}

// Role Selection Screen
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: SafeArea(
  //       child: Center(
  //         child: Column(
  //           // mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             const Padding(padding: EdgeInsets.symmetric(vertical: 40)),
  //             Image.network(
  //               "https://www.finki.ukim.mk/sites/default/files/styles/large/public/default_images/finki_52_1_2_1_62_0.png?itok=miZDgQ_6",
  //               width: double.infinity,
  //               fit: BoxFit.cover,
  //             ),
  //             Text(
  //               'Систем за консултации',
  //               style: Theme.of(context).textTheme.headlineMedium,
  //               textAlign: TextAlign.center,
  //             ),
  //             const SizedBox(height: 50),
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(30),
  //                 ),
  //               ),
  //               onPressed: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => const ProfessorDashboard(),
  //                   ),
  //                 );
  //               },
  //               child: const Text('Професор'),
  //             ),
  //             const SizedBox(height: 20),
  //             ElevatedButton(
  //               // style: ElevatedButton.styleFrom(
  //               //   padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
  //               //   shape: RoundedRectangleBorder(
  //               //     borderRadius: BorderRadius.circular(30),
  //               //   ),
  //               // ),
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: true ? Colors.white : const Color(0xFF0099FF),
  //                 foregroundColor: true ? const Color(0xFF0099FF) : Colors.white,
  //                 disabledBackgroundColor: Colors.grey[300],
  //                 disabledForegroundColor: Colors.grey[600],
  //                 padding: const EdgeInsets.symmetric(
  //                   horizontal: false ? 16.0 : 24.0,
  //                   vertical: false ? 8.0 : 12.0,
  //                 ),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(8.0),
  //                   side: true ? const BorderSide(color: Color(0xFF0099FF)) : BorderSide.none,
  //                 ),
  //                 elevation: 0,
  //               ),
  //               onPressed: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => const StudentDashboard(),
  //                   ),
  //                 );
  //               },
  //               child: const Text('Студент'),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://www.finki.ukim.mk/sites/default/files/styles/large/public/default_images/finki_52_1_2_1_62_0.png?itok=miZDgQ_6",
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Систем за консултации',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: const Color(0xFF000066),
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                _buildButton(
                  context: context,
                  text: 'Професор',
                  isPrimary: true,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfessorDashboard(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                _buildButton(
                  context: context,
                  text: 'Студент',
                  isPrimary: false,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StudentDashboard(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF0099FF) : Colors.white,
          foregroundColor: isPrimary ? Colors.white : const Color(0xFF0099FF),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isPrimary
                ? BorderSide.none
                : const BorderSide(color: Color(0xFF0099FF), width: 2),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isPrimary ? Colors.white : const Color(0xFF0099FF),
          ),
        ),
      ),
    );
  }
}

class ProfessorDashboard extends StatefulWidget {
  const ProfessorDashboard({Key? key}) : super(key: key);

  @override
  _ProfessorDashboardState createState() => _ProfessorDashboardState();
}

class _ProfessorDashboardState extends State<ProfessorDashboard> {
  List<Consultation> consultations = [];
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Sample data
    consultations = [
      Consultation(
        id: '1',
        professorId: 'prof1',
        professorName: 'Проф1',
        dateTime: DateTime.now().add(const Duration(days: 1)),
        durationMinutes: 30,
        location: '315',
        status: 'available',
      ),
    ];
  }

  List<Consultation> _getConsultationsForDay(DateTime day) {
    return consultations.where((consultation) {
      return DateUtils.isSameDay(consultation.dateTime, day);
    }).toList();
  }

  @override
  // Widget build(BuildContext context) {
  //   return DefaultTabController(
  //     length: 2,
  //     child: Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Консултации'),
  //         bottom: const TabBar(
  //           tabs: [
  //             Tab(text: 'Календар'),
  //             Tab(text: 'Листа'),
  //           ],
  //         ),
  //         actions: [
  //           IconButton(
  //             icon: const Icon(Icons.exit_to_app),
  //             onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
  //           ),
  //         ],
  //       ),
  //       body: TabBarView(
  //         children: [
  //           _buildCalendarView(),
  //           _buildListView(),
  //         ],
  //       ),
  //       floatingActionButton: FloatingActionButton(
  //         onPressed: () => _showAddConsultationDialog(context),
  //         child: const Icon(Icons.add),
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildCalendarView() {
  //   return Column(
  //     children: [
  //       TableCalendar(
  //         firstDay: DateTime.now().subtract(const Duration(days: 365)),
  //         lastDay: DateTime.now().add(const Duration(days: 365)),
  //         focusedDay: _focusedDay,
  //         calendarFormat: _calendarFormat,
  //         selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
  //         onDaySelected: (selectedDay, focusedDay) {
  //           setState(() {
  //             _selectedDay = selectedDay;
  //             _focusedDay = focusedDay;
  //           });
  //         },
  //         onFormatChanged: (format) {
  //           setState(() {
  //             _calendarFormat = format;
  //           });
  //         },
  //         eventLoader: (day) => _getConsultationsForDay(day),
  //         calendarStyle: const CalendarStyle(
  //           markersMaxCount: 3,
  //           markerSize: 8,
  //           markerDecoration: BoxDecoration(
  //             color: Colors.blue,
  //             shape: BoxShape.circle,
  //           ),
  //         ),
  //       ),
  //       const Divider(),
  //       Expanded(
  //         child: _buildConsultationsForSelectedDay(),
  //       ),
  //     ],
  //   );
  // }
  //
  // Widget _buildConsultationsForSelectedDay() {
  //   final consultationsForDay = _getConsultationsForDay(_selectedDay!);
  //
  //   if (consultationsForDay.isEmpty) {
  //     return const Center(
  //       child: Text('Нема закажани консултации за избраниот ден'),
  //     );
  //   }
  //
  //   return ListView.builder(
  //     itemCount: consultationsForDay.length,
  //     itemBuilder: (context, index) {
  //       return ConsultationCard(
  //         consultation: consultationsForDay[index],
  //         isProfessor: true,
  //         onDelete: () {
  //           setState(() {
  //             consultations.remove(consultationsForDay[index]);
  //           });
  //         },
  //       );
  //     },
  //   );
  // }
  //
  // Widget _buildListView() {
  //   return ListView.builder(
  //     itemCount: consultations.length,
  //     itemBuilder: (context, index) {
  //       return ConsultationCard(
  //         consultation: consultations[index],
  //         isProfessor: true,
  //         onDelete: () {
  //           setState(() {
  //             consultations.removeAt(index);
  //           });
  //         },
  //       );
  //     },
  //   );
  // }
  //
  // void _showAddConsultationDialog(BuildContext context) {
  //   DateTime selectedDate = DateTime.now();
  //   TimeOfDay selectedTime = TimeOfDay.now();
  //   String location = '';
  //
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Додади термин'),
  //       content: SingleChildScrollView(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ListTile(
  //               title: const Text('Датум'),
  //               subtitle: Text(DateFormat('yyyy-MM-dd').format(selectedDate)),
  //               onTap: () async {
  //                 final date = await showDatePicker(
  //                   context: context,
  //                   initialDate: selectedDate,
  //                   firstDate: DateTime.now(),
  //                   lastDate: DateTime.now().add(const Duration(days: 90)),
  //                 );
  //                 if (date != null) selectedDate = date;
  //               },
  //             ),
  //             ListTile(
  //               title: const Text('Час'),
  //               subtitle: Text(selectedTime.format(context)),
  //               onTap: () async {
  //                 final time = await showTimePicker(
  //                   context: context,
  //                   initialTime: selectedTime,
  //                 );
  //                 if (time != null) selectedTime = time;
  //               },
  //             ),
  //             TextField(
  //               decoration: const InputDecoration(labelText: 'Просторија'),
  //               onChanged: (value) => location = value,
  //             ),
  //             TextField(
  //               maxLines: 3,
  //               decoration: const InputDecoration(labelText: 'Дополнителен коментар'),
  //               onChanged: (value) => location = value,
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: [
  //         TextButton(
  //           child: const Text('Откажи'),
  //           onPressed: () => Navigator.pop(context),
  //         ),
  //         TextButton(
  //           child: const Text('Додади'),
  //           onPressed: () {
  //             if (location.isNotEmpty) {
  //               setState(() {
  //                 consultations.add(
  //                   Consultation(
  //                     id: DateTime.now().toString(),
  //                     professorId: 'prof1',
  //                     professorName: 'Проф1',
  //                     dateTime: DateTime(
  //                       selectedDate.year,
  //                       selectedDate.month,
  //                       selectedDate.day,
  //                       selectedTime.hour,
  //                       selectedTime.minute,
  //                     ),
  //                     durationMinutes: 30,
  //                     location: location,
  //                   ),
  //                 );
  //               });
  //               Navigator.pop(context);
  //             }
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
            // White indicator line
            labelColor: Theme.of(context).colorScheme.onPrimary,
            // Selected tab text color
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
        ),
        body: TabBarView(
          children: [
            _buildCalendarView(),
            _buildListView(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF0099FF),
          elevation: 4,
          onPressed: () => _showAddConsultationDialog(context),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCalendarView() {
    return Column(
      children: [
        Container(
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
        ),
        const Divider(height: 1),
        Expanded(
          child: _buildConsultationsForSelectedDay(),
        ),
      ],
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
            onDelete: () {
              setState(() {
                consultations.remove(consultationsForDay[index]);
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: consultations.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ConsultationCard(
            consultation: consultations[index],
            isProfessor: true,
            onDelete: () {
              setState(() {
                consultations.removeAt(index);
              });
            },
          ),
        );
      },
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
                subtitle: DateFormat('yyyy-MM-dd').format(selectedDate),
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
              TextField(
                decoration: InputDecoration(
                  labelText: 'Просторија',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: Color(0xFF0099FF), width: 2),
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
                    borderSide:
                        BorderSide(color: const Color(0xFF0099FF), width: 2),
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
                setState(() {
                  consultations.add(
                    Consultation(
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
                    ),
                  );
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
}

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
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
    // Sample data
    availableConsultations = [
      Consultation(
        id: '1',
        professorId: 'prof1',
        professorName: 'Проф1',
        dateTime: DateTime.now().add(const Duration(days: 1)),
        durationMinutes: 30,
        location: '315',
      ),
    ];
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
  // Widget build(BuildContext context) {
  //   return DefaultTabController(
  //     length: 2,
  //     child: Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Консултации'),
  //         bottom: const TabBar(
  //           tabs: [
  //             Tab(text: 'Календар'),
  //             Tab(text: 'Листа'),
  //           ],
  //         ),
  //         actions: [
  //           IconButton(
  //             icon: const Icon(Icons.exit_to_app),
  //             onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
  //           ),
  //         ],
  //       ),
  //       body: Column(
  //         children: [
  //           Container(
  //             padding: const EdgeInsets.all(16),
  //             color: Colors.indigo[50],
  //             child: DropdownButton<String>(
  //               value: selectedProfessor,
  //               isExpanded: true,
  //               items: professors
  //                   .map((p) => DropdownMenuItem(
  //                 value: p,
  //                 child: Text(p),
  //               ))
  //                   .toList(),
  //               onChanged: (value) {
  //                 setState(() {
  //                   selectedProfessor = value!;
  //                 });
  //               },
  //             ),
  //           ),
  //           Expanded(
  //             child: TabBarView(
  //               children: [
  //                 _buildCalendarView(),
  //                 _buildListView(),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget _buildCalendarView() {
  //   return Column(
  //     children: [
  //       TableCalendar(
  //         firstDay: DateTime.now().subtract(const Duration(days: 365)),
  //         lastDay: DateTime.now().add(const Duration(days: 365)),
  //         focusedDay: _focusedDay,
  //         calendarFormat: _calendarFormat,
  //         selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
  //         onDaySelected: (selectedDay, focusedDay) {
  //           setState(() {
  //             _selectedDay = selectedDay;
  //             _focusedDay = focusedDay;
  //           });
  //         },
  //         onFormatChanged: (format) {
  //           setState(() {
  //             _calendarFormat = format;
  //           });
  //         },
  //         eventLoader: (day) => _getConsultationsForDay(day),
  //         calendarStyle: const CalendarStyle(
  //           markersMaxCount: 3,
  //           markerSize: 8,
  //           markerDecoration: BoxDecoration(
  //             color: Colors.blue,
  //             shape: BoxShape.circle,
  //           ),
  //         ),
  //       ),
  //       const Divider(),
  //       Expanded(
  //         child: _buildConsultationsForSelectedDay(),
  //       ),
  //     ],
  //   );
  // }
  //
  // Widget _buildConsultationsForSelectedDay() {
  //   final consultationsForDay = _getConsultationsForDay(_selectedDay!);
  //
  //   if (consultationsForDay.isEmpty) {
  //     return const Center(
  //       child: Text('Нема закажани консултации за избраниот ден'),
  //     );
  //   }
  //
  //   return ListView.builder(
  //     itemCount: consultationsForDay.length,
  //     itemBuilder: (context, index) {
  //       return ConsultationCard(
  //         consultation: consultationsForDay[index],
  //         isProfessor: false,
  //         onBook: () {
  //           setState(() {
  //             consultationsForDay[index].status = 'booked';
  //           });
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('Консултациите се успешно закажани!')),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  //
  // Widget _buildListView() {
  //   return ListView.builder(
  //     itemCount: filteredConsultations.length,
  //     itemBuilder: (context, index) {
  //       return ConsultationCard(
  //         consultation: filteredConsultations[index],
  //         isProfessor: false,
  //         onBook: () {
  //           setState(() {
  //             filteredConsultations[index].status = 'booked';
  //           });
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('Консултациите се успешно закажани!')),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
            // White indicator line
            labelColor: Theme.of(context).colorScheme.onPrimary,
            // Selected tab text color
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
        ),
        body: Column(
          children: [
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.05),
            //         blurRadius: 10,
            //         offset: const Offset(0, 4),
            //       ),
            //     ],
            //   ),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Изберете професор',
            //         style: TextStyle(
            //           color: Colors.grey[600],
            //           fontSize: 14,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       Container(
            //         decoration: BoxDecoration(
            //           border: Border.all(color: Colors.grey[300]!),
            //           borderRadius: BorderRadius.circular(12),
            //         ),
            //         child: DropdownButtonHideUnderline(
            //           child: DropdownButton<String>(
            //             value: selectedProfessor,
            //             isExpanded: true,
            //             icon: const Icon(Icons.keyboard_arrow_down),
            //             padding: const EdgeInsets.symmetric(horizontal: 16),
            //             borderRadius: BorderRadius.circular(12),
            //             items: professors
            //                 .map((p) => DropdownMenuItem(
            //               value: p,
            //               child: Text(
            //                 p,
            //                 style: const TextStyle(
            //                   fontSize: 16,
            //                   color: Colors.black87,
            //                 ),
            //               ),
            //             ))
            //                 .toList(),
            //             onChanged: (value) {
            //               setState(() {
            //                 selectedProfessor = value!;
            //               });
            //             },
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
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
                // Changed to Row to place dropdowns side by side
                children: [
                  Expanded(
                    // Professor dropdown
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Изберете професор',
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
                              value: selectedProfessor,
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              borderRadius: BorderRadius.circular(12),
                              items: professors
                                  .map((p) => DropdownMenuItem(
                                        value: p,
                                        child: Text(
                                          p,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedProfessor = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16), // Spacing between dropdowns
                  Expanded(
                    // Subject dropdown
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Изберете предмет',
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
                              value: selectedSubject,
                              // You'll need to add this variable to your state
                              isExpanded: true,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              borderRadius: BorderRadius.circular(12),
                              items:
                                  subjects // You'll need to add this list to your state
                                      .map((s) => DropdownMenuItem(
                                            value: s,
                                            child: Text(
                                              s,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSubject = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildCalendarView() {
    return Column(
      children: [
        Container(
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
        ),
        const Divider(height: 1),
        Expanded(
          child: _buildConsultationsForSelectedDay(),
        ),
      ],
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
            isProfessor: false,
            onBook: () {
              setState(() {
                consultationsForDay[index].status = 'booked';
              });
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
            },
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredConsultations.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ConsultationCard(
            consultation: filteredConsultations[index],
            isProfessor: false,
            onBook: () {
              setState(() {
                filteredConsultations[index].status = 'booked';
              });
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
            },
          ),
        );
      },
    );
  }
}

// Shared Widgets
class ConsultationCard extends StatelessWidget {
  final Consultation consultation;
  final bool isProfessor;
  final VoidCallback? onDelete;
  final VoidCallback? onBook;

  const ConsultationCard({
    super.key,
    required this.consultation,
    required this.isProfessor,
    this.onDelete,
    this.onBook,
  });

  @override
  // Widget build(BuildContext context) {
  //   return Card(
  //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 consultation.professorName,
  //                 style: Theme.of(context).textTheme.titleMedium,
  //               ),
  //               Text(
  //                 consultation.status,
  //                 style: TextStyle(
  //                   color: consultation.status == 'available'
  //                       ? Colors.green
  //                       : Colors.orange,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 8),
  //           Text(
  //             'Датум: ${DateFormat('MMM dd, yyyy').format(consultation.dateTime)}',
  //           ),
  //           Text(
  //             'Час: ${DateFormat('HH:mm').format(consultation.dateTime)}',
  //           ),
  //           Text('Просторија: ${consultation.location}'),
  //           Text('Времетраење: ${consultation.durationMinutes} минути'),
  //           const SizedBox(height: 8),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               if (isProfessor && onDelete != null)
  //                 TextButton.icon(
  //                   icon: const Icon(Icons.delete),
  //                   label: const Text('Избриши'),
  //                   onPressed: onDelete,
  //                 )
  //               else if (!isProfessor &&
  //                   onBook != null &&
  //                   consultation.status == 'available')
  //                 ElevatedButton.icon(
  //                   icon: const Icon(Icons.book),
  //                   label: const Text('Закажи'),
  //                   onPressed: onBook,
  //                 ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    final statusColor = consultation.status == 'available'
        ? const Color(0xFF4CAF50) // Green for available
        : const Color(0xFFFFA726); // Orange for booked

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    consultation.status == 'available' ? 'Слободен' : 'Зафатен',
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Датум:',
              value: DateFormat('dd MMMM yyyy', 'mk')
                  .format(consultation.dateTime),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.access_time,
              label: 'Час:',
              value: DateFormat('HH:mm').format(consultation.dateTime),
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (isProfessor && onDelete != null)
                  TextButton.icon(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                    label: const Text(
                      'Избриши',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onPressed: onDelete,
                  )
                else if (!isProfessor &&
                    onBook != null &&
                    consultation.status == 'available')
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.calendar_month,
                      size: 20,
                    ),
                    label: const Text(
                      'Закажи',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0099FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: onBook,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

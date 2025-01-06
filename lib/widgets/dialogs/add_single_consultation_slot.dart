import 'package:flutter/material.dart';
import 'package:konsultacii/models/request/irregular_consultations_request.dart';
import '../../utils/date_formatter.dart';

class AddConsultationDialog extends StatefulWidget {
  const AddConsultationDialog({
    super.key,
  });

  @override
  State<AddConsultationDialog> createState() => _AddConsultationDialogState();
}

class _AddConsultationDialogState extends State<AddConsultationDialog> {
  late DateTime selectedDate;
  late TimeOfDay selectedTimeFrom;
  late TimeOfDay selectedTimeTo;
  bool isOnline = false;
  String location = '';
  String comment = '';

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    selectedTimeFrom = TimeOfDay.now();
    selectedTimeTo = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
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
              title: const Text('Час од'),
              subtitle: Text(selectedTimeFrom.format(context)),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: selectedTimeFrom,
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
                    selectedTimeFrom = time;
                  });
                }
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Час до'),
              subtitle: Text(selectedTimeTo.format(context)),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: selectedTimeTo,
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
                    selectedTimeTo = time;
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
                labelText: 'Инструкции за студентите',
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
            Row(
              children: [
                const Text(
                  'Онлајн?',
                  style: TextStyle(fontSize: 16),
                ),
                Checkbox(
                  value: isOnline,
                  onChanged: (bool? value) {
                    setState(() {
                      isOnline = value ?? false;
                    });
                  },
                  activeColor: const Color(0xFF0099FF),
                ),
              ],
            )
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
              final newConsultation = IrregularConsultationsRequest(
                startTime: selectedTimeFrom,
                endTime: selectedTimeTo,
                date: selectedDate,
                roomName: location,
                online: isOnline,
                link: '',
                studentInstructions: comment
              );
              Navigator.pop(context, newConsultation);
            }
          },
        ),
      ],
    );
  }
}

import 'package:device_calendar/device_calendar.dart';

class CalendarUtilsService {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  _getDefaultCalendar() async {
    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    final defaultCalendar = calendarsResult.data?.firstWhere(
          (calendar) => calendar.isDefault ?? false,
      orElse: () => calendarsResult.data!.first,
    );
    return defaultCalendar;
  }

  Future<void> deleteEventFromCalendar(DateTime date, String matchDescription) async {
    final defaultCalendar = await _getDefaultCalendar();

    if (defaultCalendar != null) {
      final startDate = date;
      final endDate = startDate.add(const Duration(days: 1));

      final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
          defaultCalendar.id,
          RetrieveEventsParams(startDate: startDate, endDate: endDate));

      if (eventsResult.isSuccess) {
        final events = eventsResult.data ?? [];
        try {
          final consultationEvent = events.firstWhere((event) =>
              event.title == 'Консултации' &&
              event.description?.contains(matchDescription) == true);

          await _deviceCalendarPlugin.deleteEvent(
              defaultCalendar.id, consultationEvent.eventId);
        } catch (e) {}
      }
    }
  }

  Future<void> addEventToCalendar(String title, String description, String location, TZDateTime start, TZDateTime? end, int reminderBeforeMinutes) async {
    final defaultCalendar = await _getDefaultCalendar();

    if (defaultCalendar != null) {
      final event = Event(
        defaultCalendar.id,
        title: title,
        description: description,
        location: location,
        start: start,
        end: end,
      );

      event.reminders = [
        Reminder(minutes: reminderBeforeMinutes)
      ];

      final createEventResult =
          await _deviceCalendarPlugin.createOrUpdateEvent(event);
    }

  }
}

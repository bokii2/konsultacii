class ConsultationHelper {
  static List<DateTime> generateTimeSlots({
    required DateTime date,
    required int startHour,
    required int endHour,
    required int intervalMinutes,
  }) {
    final List<DateTime> slots = [];
    final DateTime startTime = DateTime(
      date.year,
      date.month,
      date.day,
      startHour,
    );
    final DateTime endTime = DateTime(
      date.year,
      date.month,
      date.day,
      endHour,
    );

    DateTime currentSlot = startTime;
    while (currentSlot.isBefore(endTime)) {
      slots.add(currentSlot);
      currentSlot = currentSlot.add(Duration(minutes: intervalMinutes));
    }

    return slots;
  }

  static bool isWithinWorkingHours(DateTime dateTime) {
    final hour = dateTime.hour;
    return hour >= 8 && hour <= 20; // 8 AM to 8 PM
  }

  static bool isWorkingDay(DateTime date) {
    return date.weekday != DateTime.saturday && date.weekday != DateTime.sunday;
  }

  static String getTimeSlotString(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
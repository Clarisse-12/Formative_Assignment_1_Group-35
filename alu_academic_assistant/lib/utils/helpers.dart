import 'package:intl/intl.dart';

class Helpers {
  static int getAcademicWeek(DateTime currentDate) {
    DateTime termStart = DateTime(2026, 1, 5);

    int daysDifference = currentDate.difference(termStart).inDays;
    int weekNumber = (daysDifference / 7).floor() + 1;
    if (weekNumber < 1) return 1;
    if (weekNumber > 15) return 15;

    return weekNumber;
  }

  static String formatDateLong(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  static String formatDateWithDay(DateTime date) {
    return DateFormat('EEEE, MMM d').format(date);
  }

  static String getDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  static String formatTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];

      if (hour == 0) return '12:$minute AM';
      if (hour < 12) return '$hour:$minute AM';
      if (hour == 12) return '12:$minute PM';
      return '${hour - 12}:$minute PM';
    } catch (e) {
      return time; // Return original if parsing fails
    }
  }

  static int daysUntil(DateTime targetDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(targetDate.year, targetDate.month, targetDate.day);

    return target.difference(today).inDays;
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  //  double check for 7 days date
  static bool isWithinNextSevenDays(DateTime date) {
    final daysUntilDate = daysUntil(date);
    return daysUntilDate >= 0 && daysUntilDate <= 7;
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  static Map<String, dynamic> getAttendanceStatus(double percentage) {
    if (percentage >= 75) {
      return {
        'status': 'Good',
        'color': 0xFF28A745, // Green
        'message': 'Keep up the good work!',
      };
    } else if (percentage >= 60) {
      return {
        'status': 'Warning',
        'color': 0xFFFDB827,
        'message': 'Attendance needs more work',
      };
    } else {
      return {
        'status': 'Critical',
        'color': 0xFFDC3545,
        'message': 'AT RISK - Attendance is not good',
      };
    }
  }

  static String formatDueDate(DateTime dueDate) {
    final days = daysUntil(dueDate);

    if (days < 0) return 'Overdue';
    if (days == 0) return 'Due today';
    if (days == 1) return 'Due tomorrow';
    return 'Due ${formatDateShort(dueDate)}';
  }

  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

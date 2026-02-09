import 'package:intl/intl.dart';

/// Utility Helper Functions for ALU Academic Assistant
///
/// This class provides helper methods for date formatting, week calculations,
/// and other utility functions needed throughout the app.

class Helpers {
  /// Get current academic week number
  /// ALU academic calendar typically runs for 15 weeks per term
  /// Week 1 starts from a configured term start date
  static int getAcademicWeek(DateTime currentDate) {
    // ALU Term 2 2026 assumed to start on January 5, 2026 (Monday)
    // Adjust this date based on actual term start
    DateTime termStart = DateTime(2026, 1, 5);

    int daysDifference = currentDate.difference(termStart).inDays;
    int weekNumber = (daysDifference / 7).floor() + 1;

    // Clamp between 1 and 15 weeks
    if (weekNumber < 1) return 1;
    if (weekNumber > 15) return 15;

    return weekNumber;
  }

  /// Format date to readable string (e.g., "February 9, 2026")
  static String formatDateLong(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  /// Format date to short string (e.g., "Feb 9")
  static String formatDateShort(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  /// Format date with day of week (e.g., "Monday, Feb 9")
  static String formatDateWithDay(DateTime date) {
    return DateFormat('EEEE, MMM d').format(date);
  }

  /// Get day of week (e.g., "Monday")
  static String getDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  /// Format time from string "HH:mm" format
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

  /// Calculate days until a date
  static int daysUntil(DateTime targetDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(targetDate.year, targetDate.month, targetDate.day);

    return target.difference(today).inDays;
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is within next 7 days
  static bool isWithinNextSevenDays(DateTime date) {
    final daysUntilDate = daysUntil(date);
    return daysUntilDate >= 0 && daysUntilDate <= 7;
  }

  /// Get greeting based on time of day
  static String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  /// Get attendance status color and message
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
        'color': 0xFFFDB827, // Yellow
        'message': 'Attendance needs improvement',
      };
    } else {
      return {
        'status': 'Critical',
        'color': 0xFFDC3545, // Red
        'message': 'AT RISK - Attendance critically low',
      };
    }
  }

  /// Format assignment due date with context
  static String formatDueDate(DateTime dueDate) {
    final days = daysUntil(dueDate);

    if (days < 0) return 'Overdue';
    if (days == 0) return 'Due Today';
    if (days == 1) return 'Due Tomorrow';
    return 'Due ${formatDateShort(dueDate)}';
  }

  /// Generate unique ID based on timestamp
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

import 'package:intl/intl.dart';

class Utils {
  /// Converts ISO date string to formatted local date/time
  static String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return DateFormat('yyyy-MM-dd – HH:mm').format(date);
    } catch (_) {
      return dateStr;
    }
  }

  /// Returns timestamp range from 2 days before today UTC to 30 days later UTC
  static Map<String, int> getTimestampRange() {
    final now = DateTime.now().toUtc();

    // Start 2 days before today to catch ongoing events
    final start = DateTime.utc(now.year, now.month, now.day).subtract(Duration(days: 2));

    // Finish 30 days after start, end of day (23:59:59)
    final finish = start.add(Duration(days: 30, hours: 23, minutes: 59, seconds: 59));

    return {
      'start': start.millisecondsSinceEpoch ~/ 1000,
      'finish': finish.millisecondsSinceEpoch ~/ 1000,
    };
  }
}

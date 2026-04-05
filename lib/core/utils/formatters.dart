import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class Formatters {
  static final _currencyFormat = NumberFormat.currency(
    symbol: AppConstants.currencySymbol,
    decimalDigits: 0,
    locale: 'en_IN',
  );

  static final _shortFormat = NumberFormat.compact(locale: 'en_IN');

  static String currency(double amount) {
    return _currencyFormat.format(amount);
  }

  static String currencyShort(double amount) {
    if (amount >= 1000) {
      return '${AppConstants.currencySymbol}${_shortFormat.format(amount)}';
    }
    return currency(amount);
  }

  static String date(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final txDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(txDate).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return DateFormat('EEEE').format(date);
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String dateShort(DateTime date) {
    return DateFormat('dd MMM').format(date);
  }

  static String monthYear(DateTime date) {
    return DateFormat('MMMM yyyy').format(date);
  }

  static String monthKey(DateTime date) {
    return DateFormat('yyyy-MM').format(date);
  }

  static String percent(double value) {
    return '${(value * 100).toStringAsFixed(0)}%';
  }

  static String daysLeft(DateTime targetDate) {
    final diff = targetDate.difference(DateTime.now()).inDays;
    if (diff < 0) return 'Overdue';
    if (diff == 0) return 'Due today';
    if (diff == 1) return '1 day left';
    return '$diff days left';
  }
}

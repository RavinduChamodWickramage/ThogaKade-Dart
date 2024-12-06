import 'dart:convert';

class Formatters {
  static String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }

  static String formatQuantity(double quantity) {
    return quantity.toStringAsFixed(2);
  }

  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static String formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  static String formatJson(Map<String, dynamic> data) {
    return JsonEncoder.withIndent('  ').convert(data);
  }
}

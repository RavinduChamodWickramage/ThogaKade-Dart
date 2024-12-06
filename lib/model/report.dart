import 'order.dart';
import 'package:intl/intl.dart';
import 'vegetable.dart'; // Import Vegetable class

class Report {
  final DateTime reportDate;
  final List<Order> orders;
  final List<Vegetable> inventory; // Add inventory as a property

  Report({
    required this.reportDate,
    required this.orders,
    required this.inventory, // Pass inventory when creating a report
  });

  String generateDailyReport() {
    double totalSales = 0.0;
    int totalOrders = orders.length;
    StringBuffer reportBuffer = StringBuffer();

    String formattedReportDate = DateFormat('MM/dd/yyyy').format(reportDate);
    reportBuffer.writeln('Daily Sales Report - $formattedReportDate');
    reportBuffer.writeln('------------------------------------------');

    if (totalOrders == 0) {
      reportBuffer.writeln('No orders for today.');
    } else {
      reportBuffer.writeln('Total Orders: $totalOrders');
      reportBuffer.writeln('Total Sales: \$${totalSales.toStringAsFixed(2)}');
      reportBuffer.writeln('\nOrder Details:');

      for (var order in orders) {
        totalSales += order.totalAmount;
        reportBuffer.writeln('Order ID: ${order.orderID}');
        reportBuffer.writeln('Order Date: ${DateFormat('MM/dd/yyyy HH:mm:ss').format(order.timestamp)}');
        reportBuffer.writeln('Total Amount: \$${order.totalAmount.toStringAsFixed(2)}');
        reportBuffer.writeln('Items:');

        order.items.forEach((vegetableID, quantity) {
          final vegetable = inventory.firstWhere(
                (veg) => veg.id == vegetableID,
            orElse: () => throw Exception('Vegetable not found'),
          );
          reportBuffer.writeln('  - ${vegetable.name}: $quantity kg @ \$${vegetable.pricePerKg.toStringAsFixed(2)} per kg');
        });

        reportBuffer.writeln('------------------------------------------');
      }

      reportBuffer.writeln('------------------------------------------');
      reportBuffer.writeln('Total Sales for $formattedReportDate: \$${totalSales.toStringAsFixed(2)}');
    }

    return reportBuffer.toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'reportDate': reportDate.toIso8601String(),
      'orders': orders.map((order) => order.toMap()).toList(),
      'inventory': inventory.map((veg) => veg.toMap()).toList(),
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    var orderList = List<Order>.from(map['orders'].map((order) => Order.fromMap(order)));
    var inventoryList = List<Vegetable>.from(map['inventory'].map((veg) => Vegetable.fromMap(veg)));
    return Report(
      reportDate: DateTime.parse(map['reportDate']),
      orders: orderList,
      inventory: inventoryList,
    );
  }

  @override
  String toString() {
    return 'Report{reportDate: $reportDate, totalOrders: ${orders.length}, totalSales: ${orders.fold(0.0, (sum, order) => sum + order.totalAmount)}}';
  }
}

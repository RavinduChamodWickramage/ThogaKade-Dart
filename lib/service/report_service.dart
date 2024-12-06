import 'dart:async';
import 'dart:io';

import '../model/order.dart';
import '../model/vegetable.dart';
import '../repositories/inventory_repository.dart';

class ReportService {
  final InventoryRepository _inventoryRepository;

  ReportService(this._inventoryRepository);

  Future<void> generateDailyReport(DateTime date) async {
    try {
      List<Order> orders = await _inventoryRepository.getOrdersByDate(date);
      if (orders.isEmpty) {
        print('No orders found for ${date.toLocal()}');
        return;
      }
      double totalSales = 0.0;
      Map<String, double> vegetableSales = {};

      for (var order in orders) {
        totalSales += order.totalAmount;
        order.items.forEach((vegId, quantity) {
          vegetableSales[vegId] = (vegetableSales[vegId] ?? 0) + quantity;
        });
      }

      print('Daily Report for ${date.toLocal()}');
      print('-----------------------------');
      print('Total Sales: \$${totalSales.toStringAsFixed(2)}');
      print('Vegetable Sales Breakdown:');
      for (var entry in vegetableSales.entries) {
        final vegetable = await _inventoryRepository.getVegetableById(entry.key);
        print('${vegetable.name}: ${entry.value} kg sold');
      }
    } catch (e) {
      print('Failed to generate daily report: $e');
    }
  }

  Future<void> generateInventoryReport() async {
    try {
      List<Vegetable> inventory = await _inventoryRepository.getInventory();
      if (inventory.isEmpty) {
        print('No vegetables in inventory.');
        return;
      }

      double totalValue = 0.0;
      print('Inventory Report');
      print('-----------------------------');
      for (var vegetable in inventory) {
        double vegetableValue = vegetable.availableQuantity * vegetable.pricePerKg;
        totalValue += vegetableValue;
        print('${vegetable.name} (ID: ${vegetable.id}): ${vegetable.availableQuantity} kg available, \$${vegetableValue.toStringAsFixed(2)} in value');
      }

      print('-----------------------------');
      print('Total Inventory Value: \$${totalValue.toStringAsFixed(2)}');
    } catch (e) {
      print('Failed to generate inventory report: $e');
    }
  }

  Future<void> generateSalesReport(DateTime startDate, DateTime endDate) async {
    try {
      List<Order> orders = await _inventoryRepository.getOrdersByDate(startDate);
      if (orders.isEmpty) {
        print('No orders found between ${startDate.toLocal()} and ${endDate.toLocal()}');
        return;
      }

      double totalSales = 0.0;
      Map<String, double> vegetableSales = {};

      for (var order in orders) {
        totalSales += order.totalAmount;
        order.items.forEach((vegId, quantity) {
          vegetableSales[vegId] = (vegetableSales[vegId] ?? 0) + quantity;
        });
      }

      print('Sales Report from ${startDate.toLocal()} to ${endDate.toLocal()}');
      print('-----------------------------');
      print('Total Sales: \$${totalSales.toStringAsFixed(2)}');
      print('Vegetable Sales Breakdown:');
      for (var entry in vegetableSales.entries) {
        final vegetable = await _inventoryRepository.getVegetableById(entry.key);
        print('${vegetable.name}: ${entry.value} kg sold');
      }
    } catch (e) {
      print('Failed to generate sales report: $e');
    }
  }
}

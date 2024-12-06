import 'dart:convert';
import 'dart:io';

import '../model/order.dart';
import '../model/vegetable.dart';

class FileService {
  final String inventoryFilePath = 'inventory.json';
  final String orderHistoryFilePath = 'order_history.json';

  Future<List<Vegetable>> loadInventory() async {
    try {
      final file = File(inventoryFilePath);
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      final List<dynamic> json = jsonDecode(contents);
      return json.map((item) => Vegetable.fromMap(item)).toList();
    } catch (e) {
      throw StorageException('Failed to load inventory: $e');
    }
  }

  Future<void> saveInventory(List<Vegetable> inventory) async {
    try {
      final file = File(inventoryFilePath);
      final jsonData = jsonEncode(inventory.map((veg) => veg.toMap()).toList());
      await file.writeAsString(jsonData);
    } catch (e) {
      throw StorageException('Failed to save inventory: $e');
    }
  }

  Future<List<Order>> loadOrderHistory() async {
    try {
      final file = File(orderHistoryFilePath);
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      final List<dynamic> json = jsonDecode(contents);
      return json.map((item) => Order.fromMap(item)).toList();
    } catch (e) {
      throw StorageException('Failed to load order history: $e');
    }
  }

  Future<void> saveOrderHistory(List<Order> orders) async {
    try {
      final file = File(orderHistoryFilePath);
      final jsonData = jsonEncode(orders.map((order) => order.toMap()).toList());
      await file.writeAsString(jsonData);
    } catch (e) {
      throw StorageException('Failed to save order history: $e');
    }
  }

  Future<void> backupData() async {
    try {
      final inventory = await loadInventory();
      final orderHistory = await loadOrderHistory();
      final backupInventoryFile = File('backup_inventory.json');
      final backupOrderFile = File('backup_order_history.json');

      await backupInventoryFile.writeAsString(jsonEncode(inventory.map((veg) => veg.toMap()).toList()));
      await backupOrderFile.writeAsString(jsonEncode(orderHistory.map((order) => order.toMap()).toList()));
      print('Backup completed successfully.');
    } catch (e) {
      throw StorageException('Failed to backup data: $e');
    }
  }
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);
  @override
  String toString() => 'StorageException: $message';
}

import 'dart:async';
import '../model/order.dart';
import '../model/vegetable.dart';

extension DateTimeComparison on DateTime {
  bool isSameDay(DateTime other) {
    return this.year == other.year && this.month == other.month && this.day == other.day;
  }
}

class InventoryRepository {
  static List<Vegetable> _inventory = [];
  static List<Order> _orders = [];

  Future<void> addVegetable(Vegetable vegetable) async {
    _inventory.add(vegetable);
  }

  Future<void> removeVegetable(String id) async {
    _inventory.removeWhere((veg) => veg.id == id);
  }

  Future<void> updateStock(String id, double quantity) async {
    try {
      final vegetable = _inventory.firstWhere((veg) => veg.id == id);
      vegetable.availableQuantity += quantity;
    } catch (e) {
      throw Exception('Vegetable with ID $id not found.');
    }
  }

  Future<List<Vegetable>> getInventory() async {
    return _inventory;
  }

  Future<Vegetable> getVegetableById(String id) async {
    try {
      return _inventory.firstWhere((veg) => veg.id == id);
    } catch (e) {
      throw Exception('Vegetable with ID $id not found.');
    }
  }

  Future<void> processOrder(Order order) async {
    _orders.add(order);
  }

  Future<List<Order>> getOrdersByDate(DateTime startDate) async {
    return _orders.where((order) {
      final orderDate = order.timestamp;
      return orderDate.isAfter(startDate) && orderDate.isBefore(startDate.add(Duration(days: 1)));
    }).toList();
  }

  Future<List<Order>> getOrders() async {
    return _orders;
  }
}

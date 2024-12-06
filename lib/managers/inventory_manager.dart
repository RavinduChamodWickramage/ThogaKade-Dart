import 'dart:async';
import '../model/order.dart';
import '../model/vegetable.dart';
import '../repositories/inventory_repository.dart';

class InventoryManager {
  late InventoryRepository _inventoryRepository;

  InventoryManager({InventoryRepository? inventoryRepository}) {
    _inventoryRepository = inventoryRepository ?? InventoryRepository();
  }


  Future<void> addVegetable(Vegetable vegetable) async {
    try {
      await _inventoryRepository.addVegetable(vegetable);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeVegetable(String id) async {
    try {
      await _inventoryRepository.removeVegetable(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStock(String id, double quantity) async {
    try {
      await _inventoryRepository.updateStock(id, quantity);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Vegetable>> getInventory() async {
    try {
      return await _inventoryRepository.getInventory();
    } catch (e) {
      rethrow;
    }
  }

  Future<Vegetable> getVegetableById(String id) async {
    try {
      return await _inventoryRepository.getVegetableById(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> processOrder(Order order) async {
    try {
      await _inventoryRepository.processOrder(order);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Order>> getOrdersByDate(DateTime date) async {
    try {
      return await _inventoryRepository.getOrdersByDate(date);
    } catch (e) {
      rethrow;
    }
  }
}

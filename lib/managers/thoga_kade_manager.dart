import 'dart:async';

import '../model/order.dart';
import '../model/report.dart';
import '../model/vegetable.dart';
import '../repositories/inventory_repository.dart';

abstract class ThogaKadeState {}

class LoadingState extends ThogaKadeState {}

class LoadedState extends ThogaKadeState {}

class ErrorState extends ThogaKadeState {}

class ThogaKadeManager {
  static final ThogaKadeManager _instance = ThogaKadeManager._internal();
  late InventoryRepository _inventoryRepository;
  ThogaKadeState _state = LoadedState();

  factory ThogaKadeManager() {
    return _instance;
  }

  ThogaKadeManager._internal() {
    _inventoryRepository = InventoryRepository();
  }

  InventoryRepository get inventoryRepository => _inventoryRepository;

  set inventoryRepository(InventoryRepository inventoryRepository) {
    _inventoryRepository = inventoryRepository;
  }

  ThogaKadeState get state => _state;

  Future<void> addVegetable(Vegetable vegetable) async {
    try {
      _state = LoadingState();
      notifyStateChange();
      await _inventoryRepository.addVegetable(vegetable);
      _state = LoadedState();
      notifyStateChange();
    } catch (e) {
      _state = ErrorState();
      notifyStateChange();
      rethrow;
    }
  }

  Future<void> removeVegetable(String id) async {
    try {
      _state = LoadingState();
      notifyStateChange();
      await _inventoryRepository.removeVegetable(id);
      _state = LoadedState();
      notifyStateChange();
    } catch (e) {
      _state = ErrorState();
      notifyStateChange();
      rethrow;
    }
  }

  Future<void> updateStock(String id, double quantity) async {
    try {
      _state = LoadingState();
      notifyStateChange();
      await _inventoryRepository.updateStock(id, quantity);
      _state = LoadedState();
      notifyStateChange();
    } catch (e) {
      _state = ErrorState();
      notifyStateChange();
      rethrow;
    }
  }

  Future<void> processOrder(Order order) async {
    try {
      _state = LoadingState();
      notifyStateChange();
      await _inventoryRepository.processOrder(order);
      _state = LoadedState();
      notifyStateChange();
    } catch (e) {
      _state = ErrorState();
      notifyStateChange();
      rethrow;
    }
  }

  Future<void> generateReport(DateTime date) async {
    try {
      _state = LoadingState();
      notifyStateChange();
      List<Order> orders = await _inventoryRepository.getOrdersByDate(date);
      Report report = Report(reportDate: date, orders: orders, inventory: []);
      print(report.generateDailyReport());
      _state = LoadedState();
      notifyStateChange();
    } catch (e) {
      _state = ErrorState();
      notifyStateChange();
      rethrow;
    }
  }

  void notifyStateChange() {
    print('State Changed: ${_state.runtimeType}');
  }
}

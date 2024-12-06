import 'package:thoga_kade/managers/thoga_kade_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:thoga_kade/model/order.dart';
import 'package:thoga_kade/model/vegetable.dart';
import 'package:thoga_kade/repositories/inventory_repository.dart';

class MockInventoryRepository extends Mock implements InventoryRepository {}

void main() {
  late ThogaKadeManager manager;
  late MockInventoryRepository mockInventoryRepository;

  setUp(() {
    mockInventoryRepository = MockInventoryRepository();
    manager = ThogaKadeManager();
    manager.inventoryRepository = mockInventoryRepository;
  });

  group('ThogaKadeManager', () {
    test('should change state to LoadingState and then LoadedState when adding vegetable successfully', () async {
      Vegetable vegetable = Vegetable(id: '1', name: 'Carrot', pricePerKg: 30.0, availableQuantity: 50.0, category: 'root', expiryDate: DateTime.now());

      when(mockInventoryRepository.addVegetable(vegetable)).thenAnswer((_) async => null);

      await manager.addVegetable(vegetable);

      expect(manager.state, isA<LoadedState>());
    });

    test('should change state to ErrorState when adding vegetable fails', () async {
      Vegetable vegetable = Vegetable(id: '1', name: 'Carrot', pricePerKg: 30.0, availableQuantity: 50.0, category: 'root', expiryDate: DateTime.now());

      when(mockInventoryRepository.addVegetable(vegetable)).thenThrow(Exception('Failed to add vegetable'));

      try {
        await manager.addVegetable(vegetable);
      } catch (_) {}

      expect(manager.state, isA<ErrorState>());
    });

    test('should change state to LoadingState and then LoadedState when removing vegetable successfully', () async {
      when(mockInventoryRepository.removeVegetable('1')).thenAnswer((_) async => null);

      await manager.removeVegetable('1');

      expect(manager.state, isA<LoadedState>());
    });

    test('should change state to ErrorState when removing vegetable fails', () async {
      when(mockInventoryRepository.removeVegetable('1')).thenThrow(Exception('Failed to remove vegetable'));

      try {
        await manager.removeVegetable('1');
      } catch (_) {}

      expect(manager.state, isA<ErrorState>());
    });

    test('should change state to LoadingState and then LoadedState when updating stock successfully', () async {
      when(mockInventoryRepository.updateStock('1', 20.0)).thenAnswer((_) async => null);

      await manager.updateStock('1', 20.0);

      expect(manager.state, isA<LoadedState>());
    });

    test('should change state to ErrorState when updating stock fails', () async {
      when(mockInventoryRepository.updateStock('1', 20.0)).thenThrow(Exception('Failed to update stock'));

      try {
        await manager.updateStock('1', 20.0);
      } catch (_) {}

      expect(manager.state, isA<ErrorState>());
    });

    test('should change state to LoadingState and then LoadedState when processing order successfully', () async {
      Order order = Order(orderID: '1', items: {'1': 5.0}, totalAmount: 150.0, timestamp: DateTime.now());

      when(mockInventoryRepository.processOrder(order)).thenAnswer((_) async => null);

      await manager.processOrder(order);

      expect(manager.state, isA<LoadedState>());
    });

    test('should change state to ErrorState when processing order fails', () async {
      Order order = Order(orderID: '1', items: {'1': 5.0}, totalAmount: 150.0, timestamp: DateTime.now());

      when(mockInventoryRepository.processOrder(order)).thenThrow(Exception('Failed to process order'));

      try {
        await manager.processOrder(order);
      } catch (_) {}

      expect(manager.state, isA<ErrorState>());
    });

    test('should change state to LoadingState and then LoadedState when generating report successfully', () async {
      DateTime date = DateTime(2025, 01, 01);
      List<Order> orders = [
        Order(orderID: '1', items: {'1': 5.0}, totalAmount: 150.0, timestamp: date)
      ];

      when(mockInventoryRepository.getOrdersByDate(date)).thenAnswer((_) async => orders);

      await manager.generateReport(date);

      expect(manager.state, isA<LoadedState>());
    });

    test('should change state to ErrorState when generating report fails', () async {
      DateTime date = DateTime(2025, 01, 01);

      when(mockInventoryRepository.getOrdersByDate(date)).thenThrow(Exception('Failed to generate report'));

      try {
        await manager.generateReport(date);
      } catch (_) {}

      expect(manager.state, isA<ErrorState>());
    });
  });
}

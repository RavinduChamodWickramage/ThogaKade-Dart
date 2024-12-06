import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:thoga_kade/managers/inventory_manager.dart';
import 'package:thoga_kade/model/order.dart';
import 'package:thoga_kade/model/vegetable.dart';
import 'package:thoga_kade/repositories/inventory_repository.dart';

class MockInventoryRepository extends Mock implements InventoryRepository {}

void main() {
  late InventoryManager manager;
  late MockInventoryRepository mockInventoryRepository;

  setUp(() {
    mockInventoryRepository = MockInventoryRepository();
    manager = InventoryManager(inventoryRepository: mockInventoryRepository);
  });

  group('InventoryManager Tests', () {
    test('should add vegetable successfully', () async {
      final vegetable = Vegetable(
        id: '1',
        name: 'Carrot',
        pricePerKg: 2.5,
        availableQuantity: 10,
        category: 'root',
        expiryDate: DateTime(2024, 12, 6),
      );
      when(mockInventoryRepository.addVegetable(vegetable)).thenAnswer((_) async {});
      await manager.addVegetable(vegetable);
      verify(mockInventoryRepository.addVegetable(vegetable)).called(1);
    });

    test('should remove vegetable successfully', () async {
      when(mockInventoryRepository.removeVegetable('1')).thenAnswer((_) async {});
      await manager.removeVegetable('1');
      verify(mockInventoryRepository.removeVegetable('1')).called(1);
    });

    test('should update stock successfully', () async {
      when(mockInventoryRepository.updateStock('1', 5.0)).thenAnswer((_) async {});
      await manager.updateStock('1', 5.0);
      verify(mockInventoryRepository.updateStock('1', 5.0)).called(1);
    });

    test('should fetch inventory successfully', () async {
      List<Vegetable> mockInventory = [
        Vegetable(id: '1', name: 'Carrot', pricePerKg: 2.5, availableQuantity: 10, category: 'root', expiryDate: DateTime(2024, 12, 6)),
        Vegetable(id: '2', name: 'Potato', pricePerKg: 1.2, availableQuantity: 20, category: 'root', expiryDate: DateTime(2024, 12, 6)),
      ];
      when(mockInventoryRepository.getInventory()).thenAnswer((_) async => mockInventory);
      List<Vegetable> inventory = await manager.getInventory();
      expect(inventory, mockInventory);
    });

    test('should process order successfully', () async {
      final order = Order(
        orderID: '123',
        items: {
          '1': 5.0,
        },
        totalAmount: 0.0,
        timestamp: DateTime.now(),
      );

      final inventory = [
        Vegetable(id: '1', name: 'Carrot', pricePerKg: 2.5, availableQuantity: 10, category: 'root', expiryDate: DateTime(2024, 12, 6)),
      ];

      order.calculateTotal(inventory);

      expect(order.totalAmount, 12.5);

      when(mockInventoryRepository.processOrder(order)).thenAnswer((_) async {});
      await manager.processOrder(order);
      verify(mockInventoryRepository.processOrder(order)).called(1);
    });

    test('should get orders by date successfully', () async {
      final mockOrders = [
        Order(
          orderID: '1',
          items: {'1': 5.0},
          totalAmount: 12.5,
          timestamp: DateTime(2024, 12, 6),
        ),
        Order(
          orderID: '2',
          items: {'2': 3.0},
          totalAmount: 6.0,
          timestamp: DateTime(2024, 12, 6),
        ),
      ];
      when(mockInventoryRepository.getOrdersByDate(DateTime(2024, 12, 6)))
          .thenAnswer((_) async => mockOrders);
      List<Order> orders = await manager.getOrdersByDate(DateTime(2024, 12, 6));
      expect(orders, mockOrders);
    });
  });
}

import 'dart:convert';
import 'dart:io';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:thoga_kade/repositories/inventory_repository.dart';
import 'package:thoga_kade/model/order.dart';
import 'package:thoga_kade/model/vegetable.dart';

class MockFile extends Mock implements File {}

void main() {
  late InventoryRepository inventoryRepository;
  late MockFile mockInventoryFile;
  late MockFile mockOrderHistoryFile;

  setUp(() {
    mockInventoryFile = MockFile();
    mockOrderHistoryFile = MockFile();
    inventoryRepository = InventoryRepository();
  });

  test('should load inventory successfully', () async {
    final mockInventory = [
      Vegetable(
        id: '1',
        name: 'Tomato',
        pricePerKg: 100.0,
        availableQuantity: 10.0,
        category: 'root',
        expiryDate: DateTime(2025, 1, 1),
      ),
    ];

    when(mockInventoryFile.exists()).thenAnswer((_) async => true);
    when(mockInventoryFile.readAsString()).thenAnswer(
          (_) async => jsonEncode(mockInventory.map((e) => e.toMap()).toList()),
    );

    final inventory = await inventoryRepository.getInventory();

    expect(inventory, isNotEmpty);
    expect(inventory[0].name, 'Tomato');
  });

  test('should add vegetable to inventory', () async {
    final vegetable = Vegetable(
      id: '2',
      name: 'Carrot',
      pricePerKg: 50.0,
      availableQuantity: 20.0,
      category: 'root',
      expiryDate: DateTime(2025, 2, 1),
    );

    when(mockInventoryFile.exists()).thenAnswer((_) async => true);
    when(mockInventoryFile.readAsString()).thenAnswer(
          (_) async => jsonEncode([Vegetable(
        id: '1',
        name: 'Tomato',
        pricePerKg: 100.0,
        availableQuantity: 10.0,
        category: 'root',
        expiryDate: DateTime(2025, 1, 1),
      ).toMap()]),
    );

    await inventoryRepository.addVegetable(vegetable);

    final inventory = await inventoryRepository.getInventory();
    expect(inventory.length, 2);
    expect(inventory.last.name, 'Carrot');
  });

  test('should remove vegetable from inventory', () async {
    final vegetableIdToRemove = '1';

    when(mockInventoryFile.exists()).thenAnswer((_) async => true);
    when(mockInventoryFile.readAsString()).thenAnswer(
          (_) async => jsonEncode([Vegetable(
        id: '1',
        name: 'Tomato',
        pricePerKg: 100.0,
        availableQuantity: 10.0,
        category: 'root',
        expiryDate: DateTime(2025, 1, 1),
      ).toMap()]),
    );

    await inventoryRepository.removeVegetable(vegetableIdToRemove);

    final inventory = await inventoryRepository.getInventory();
    expect(inventory.isEmpty, true);
  });

  test('should update vegetable stock successfully', () async {
    final vegetableIdToUpdate = '1';
    final additionalQuantity = 5.0;

    final vegetable = Vegetable(
      id: vegetableIdToUpdate,
      name: 'Tomato',
      pricePerKg: 100.0,
      availableQuantity: 10.0,
      category: 'root',
      expiryDate: DateTime(2025, 1, 1),
    );

    when(mockInventoryFile.exists()).thenAnswer((_) async => true);
    when(mockInventoryFile.readAsString()).thenAnswer(
          (_) async => jsonEncode([vegetable.toMap()]),
    );

    await inventoryRepository.updateStock(vegetableIdToUpdate, additionalQuantity);

    expect(vegetable.availableQuantity, 15.0);
  });

  test('should throw exception if vegetable not found during stock update', () async {
    final vegetableIdToUpdate = '2';
    final additionalQuantity = 5.0;

    when(mockInventoryFile.exists()).thenAnswer((_) async => true);
    when(mockInventoryFile.readAsString()).thenAnswer(
          (_) async => jsonEncode([
        Vegetable(
          id: '1',
          name: 'Tomato',
          pricePerKg: 100.0,
          availableQuantity: 10.0,
          category: 'root',
          expiryDate: DateTime(2025, 1, 1),
        ).toMap()
      ]),
    );

    try {
      await inventoryRepository.updateStock(vegetableIdToUpdate, additionalQuantity);
      fail('Exception should have been thrown');
    } catch (e) {
      expect(e, isA<StateError>());
    }
  });

  test('should get vegetable by ID', () async {
    final vegetable = Vegetable(
      id: '1',
      name: 'Tomato',
      pricePerKg: 100.0,
      availableQuantity: 10.0,
      category: 'root',
      expiryDate: DateTime(2025, 1, 1),
    );

    when(mockInventoryFile.exists()).thenAnswer((_) async => true);
    when(mockInventoryFile.readAsString()).thenAnswer(
          (_) async => jsonEncode([vegetable.toMap()]),
    );

    final result = await inventoryRepository.getVegetableById('1');

    expect(result.id, '1');
    expect(result.name, 'Tomato');
  });

  test('should throw exception if vegetable not found by ID', () async {
    when(mockInventoryFile.exists()).thenAnswer((_) async => true);
    when(mockInventoryFile.readAsString()).thenAnswer(
          (_) async => jsonEncode([]),
    );

    try {
      await inventoryRepository.getVegetableById('1');
      fail('Exception should have been thrown');
    } catch (e) {
      expect(e, isA<StateError>());
    }
  });

  test('should process order successfully', () async {
    final order = Order(
      orderID: '1',
      items: {'1': 2.0},
      totalAmount: 200.0,
      timestamp: DateTime.now(),
    );

    when(mockInventoryFile.exists()).thenAnswer((_) async => true);
    when(mockInventoryFile.readAsString()).thenAnswer(
          (_) async => jsonEncode([Vegetable(
        id: '1',
        name: 'Tomato',
        pricePerKg: 100.0,
        availableQuantity: 10.0,
        category: 'root',
        expiryDate: DateTime(2025, 1, 1),
      ).toMap()]),
    );

    when(mockOrderHistoryFile.exists()).thenAnswer((_) async => true);
    when(mockOrderHistoryFile.readAsString()).thenAnswer(
          (_) async => jsonEncode([]),
    );

    await inventoryRepository.processOrder(order);

    final orders = await inventoryRepository.getOrders();
    expect(orders.length, 1);
    expect(orders[0].orderID, '1');
  });

  test('should get all orders successfully', () async {
    final order = Order(
      orderID: '1',
      items: {'1': 2.0},
      totalAmount: 200.0,
      timestamp: DateTime.now(),
    );

    when(mockOrderHistoryFile.exists()).thenAnswer((_) async => true);
    when(mockOrderHistoryFile.readAsString()).thenAnswer(
          (_) async => jsonEncode([order.toMap()]),
    );

    final orders = await inventoryRepository.getOrders();

    expect(orders, isNotEmpty);
    expect(orders[0].orderID, '1');
  });
}

import 'dart:io';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:thoga_kade/cli/command_handler.dart';
import 'package:thoga_kade/managers/thoga_kade_manager.dart';
import 'package:thoga_kade/repositories/inventory_repository.dart';
import 'package:thoga_kade/model/order.dart';
import 'package:thoga_kade/model/vegetable.dart';

class MockInventoryRepository extends Mock implements InventoryRepository {}

class MockThogaKadeManager extends Mock implements ThogaKadeManager {}

void main() {
  late CommandHandler commandHandler;
  late MockInventoryRepository mockInventoryRepository;
  late MockThogaKadeManager mockManager;

  setUp(() {
    mockInventoryRepository = MockInventoryRepository();
    mockManager = MockThogaKadeManager();
    commandHandler = CommandHandler(mockManager, mockInventoryRepository);
  });

  test('should view inventory successfully', () async {
    final inventory = [
      Vegetable(
        id: '1',
        name: 'Tomato',
        pricePerKg: 100.0,
        availableQuantity: 10.0,
        category: 'root',
        expiryDate: DateTime(2025, 1, 1),
      ),
    ];

    when(mockInventoryRepository.getInventory()).thenAnswer((_) async => inventory);

    when(stdin.readLineSync()).thenReturn('1');

    await commandHandler.handleUserInput();

    verify(mockInventoryRepository.getInventory()).called(1);
  });
}

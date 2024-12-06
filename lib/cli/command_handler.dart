import 'dart:io';

import '../managers/thoga_kade_manager.dart';
import '../model/order.dart';
import '../model/vegetable.dart';
import '../repositories/inventory_repository.dart';
import '../utils/formatters.dart';
import '../utils/validators.dart';

class CommandHandler {
  final ThogaKadeManager _manager;
  final InventoryRepository _inventoryRepository;

  CommandHandler(this._manager, this._inventoryRepository);

  void displayMenu() {
    print('\nWelcome to Thoga Kade - Vegetable Shop');
    print('1. View Inventory');
    print('2. Add Vegetable');
    print('3. Remove Vegetable');
    print('4. Update Vegetable Stock');
    print('5. Place Order');
    print('6. View Orders');
    print('7. Generate Report');
    print('8. Exit\n');
  }

  Future<void> handleUserInput() async {
    while (true) {
      displayMenu();
      stdout.write('\nEnter your choice: ');
      String? choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          await _viewInventory();
          break;
        case '2':
          await _addVegetable();
          break;
        case '3':
          await _removeVegetable();
          break;
        case '4':
          await _updateVegetableStock();
          break;
        case '5':
          await _placeOrder();
          break;
        case '6':
          await _viewOrders();
          break;
        case '7':
          await _generateReport();
          break;
        case '8':
          print('Exiting Thoga Kade...');
          return;
        default:
          print('Invalid option. Please try again.');
      }
    }
  }

  Future<void> _viewInventory() async {
    print('Current Inventory:');
    List<Vegetable> inventory = await _inventoryRepository.getInventory();
    if (inventory.isEmpty) {
      print('No vegetables in stock.');
    } else {
      for (var vegetable in inventory) {
        print('${vegetable.name} (ID: ${vegetable.id}) - ${vegetable.availableQuantity} kg available, Price: ${Formatters.formatCurrency(vegetable.pricePerKg)}');
      }
    }
  }

  Future<void> _addVegetable() async {
    stdout.write('Enter vegetable name: ');
    String? name = stdin.readLineSync();
    if (name == null || !Validators.isValidName(name)) {
      print('Invalid name. Please try again.');
      return;
    }

    stdout.write('Enter price per kg: ');
    String? priceStr = stdin.readLineSync();
    if (priceStr == null || !Validators.isValidPositiveNumber(priceStr)) {
      print('Invalid price. Please enter a positive number.');
      return;
    }
    double price = double.parse(priceStr);

    stdout.write('Enter available quantity (kg): ');
    String? quantityStr = stdin.readLineSync();
    if (quantityStr == null || !Validators.isValidPositiveNumber(quantityStr)) {
      print('Invalid quantity. Please enter a positive number.');
      return;
    }
    double quantity = double.parse(quantityStr);

    stdout.write('Enter category (leafy, root, fruit, stem, flower, tuber): ');
    String? category = stdin.readLineSync();

    stdout.write('Enter expiry date (YYYY-MM-DD): ');
    String? expiryStr = stdin.readLineSync();
    DateTime expiryDate;
    try {
      expiryDate = DateTime.parse(expiryStr ?? '');
    } catch (e) {
      print('Invalid date format. Please use YYYY-MM-DD.');
      return;
    }

    Vegetable vegetable = Vegetable(
      id: _generateId(),
      name: name,
      pricePerKg: price,
      availableQuantity: quantity,
      category: category ?? 'leafy',
      expiryDate: expiryDate,
    );

    await _manager.addVegetable(vegetable);
    print('${vegetable.toString()}: Vegetable added successfully!');
  }

  Future<void> _removeVegetable() async {
    stdout.write('Enter vegetable ID to remove: ');
    String? id = stdin.readLineSync();
    if (id == null || !Validators.isValidId(id)) {
      print('Invalid ID. Please try again.');
      return;
    }

    try {
      await _manager.removeVegetable(id);
      print('Vegetable removed successfully!');
    } catch (e) {
      print('Error removing vegetable: $e');
    }
  }

  Future<void> _updateVegetableStock() async {
    stdout.write('Enter vegetable ID to update stock: ');
    String? id = stdin.readLineSync();
    if (id == null || !Validators.isValidId(id)) {
      print('Invalid ID. Please try again.');
      return;
    }

    stdout.write('Enter the quantity to add: ');
    String? quantityStr = stdin.readLineSync();
    if (quantityStr == null || !Validators.isValidPositiveNumber(quantityStr)) {
      print('Invalid quantity. Please enter a positive number.');
      return;
    }
    double quantity = double.parse(quantityStr);

    try {
      await _manager.updateStock(id, quantity);
      print('Stock updated successfully!');
    } catch (e) {
      print('Error updating stock: $e');
    }
  }

  Future<void> _placeOrder() async {
    stdout.write('Enter order ID: ');
    String? orderId = stdin.readLineSync();
    if (orderId == null || orderId.isEmpty) {
      print('Invalid order ID. Please try again.');
      return;
    }

    Map<String, double> items = {};
    while (true) {
      stdout.write('Enter vegetable ID (or type "done" to finish): ');
      String? vegetableId = stdin.readLineSync();
      if (vegetableId == null || vegetableId == 'done') {
        break;
      }

      if (!Validators.isValidId(vegetableId)) {
        print('Invalid vegetable ID. Please try again.');
        continue;
      }

      stdout.write('Enter quantity: ');
      String? quantityStr = stdin.readLineSync();
      if (quantityStr == null || !Validators.isValidPositiveNumber(quantityStr)) {
        print('Invalid quantity. Please enter a positive number.');
        continue;
      }
      double quantity = double.parse(quantityStr);

      items[vegetableId] = quantity;
    }

    if (items.isEmpty) {
      print('No items in order.');
      return;
    }

    double totalAmount = await _calculateTotalAmount(items);

    Order order = Order(
      orderID: orderId,
      items: items,
      totalAmount: totalAmount,
      timestamp: DateTime.now(),
    );

    try {
      await _manager.processOrder(order);
      print('${order.toString()}: Order placed successfully!');
    } catch (e) {
      print('Error placing order: $e');
    }
  }

  Future<void> _viewOrders() async {
    print('Order History:');
    List<Order> orders = await _inventoryRepository.getOrders();
    if (orders.isEmpty) {
      print('No orders placed yet.');
    } else {
      for (var order in orders) {
        print('Order ID: ${order.orderID}, Total: ${Formatters.formatCurrency(order.totalAmount)}, Timestamp: ${Formatters.formatDate(order.timestamp)}');
      }
    }
  }

  Future<void> _generateReport() async {
    stdout.write('Enter date for the report (YYYY-MM-DD) or press Enter for today: ');
    String? dateStr = stdin.readLineSync();

    DateTime date;
    if (dateStr == null || dateStr.isEmpty || dateStr.toLowerCase() == 'today') {
      date = DateTime.now();
    } else if (dateStr.toLowerCase() == 'yesterday') {
      date = DateTime.now().subtract(Duration(days: 1));
    } else {
      try {
        date = DateTime.parse(dateStr);
      } catch (e) {
        print('Invalid date format. Please use YYYY-MM-DD.');
        return;
      }
    }

    print('Generating report for: ${Formatters.formatDate(date)}');
    await _manager.generateReport(date);
    print('Report generated successfully!');
  }

  Future<double> _calculateTotalAmount(Map<String, double> items) async {
    double totalAmount = 0.0;

    for (var vegId in items.keys) {
      final vegetable = await _inventoryRepository.getVegetableById(vegId);
      totalAmount += vegetable.pricePerKg * items[vegId]!;
    }

    return totalAmount;
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

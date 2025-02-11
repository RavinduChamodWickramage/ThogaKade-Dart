import 'vegetable.dart';

class Order {
  final String orderID;
  final Map<String, double> items;
  double totalAmount;
  final DateTime timestamp;

  Order({
    required this.orderID,
    required this.items,
    required this.totalAmount,
    required this.timestamp,
  });

  void calculateTotal(List<Vegetable> inventory) {
    totalAmount = 0.0;

    items.forEach((vegetableID, quantity) {
      final vegetable = inventory.firstWhere(
            (veg) => veg.id == vegetableID,
        orElse: () => throw Exception('Vegetable not found'),
      );

      if (vegetable.isExpired()) {
        throw Exception('Vegetable ${vegetable.name} is expired and cannot be ordered.');
      }

      if (vegetable.availableQuantity < quantity) {
        throw Exception('Not enough stock for ${vegetable.name}. Available: ${vegetable.availableQuantity}, Requested: $quantity');
      }

      totalAmount += vegetable.pricePerKg * quantity;

      vegetable.updateStock(-quantity);
    });
  }

  String generateReceipt() {
    String receipt = 'Order ID: $orderID\n';
    receipt += 'Date: ${timestamp.toIso8601String()}\n';
    receipt += 'Items Ordered:\n';

    items.forEach((vegetableID, quantity) {
      receipt += '  - $vegetableID: $quantity kg\n';
    });

    receipt += 'Total Amount: \$${totalAmount.toStringAsFixed(2)}\n';
    return receipt;
  }

  Map<String, dynamic> toMap() {
    return {
      'orderID': orderID,
      'items': items,
      'totalAmount': totalAmount,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderID: map['orderID'],
      items: Map<String, double>.from(map['items']),
      totalAmount: map['totalAmount'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  @override
  String toString() {
    String orderDetails = 'Order ID: $orderID\n';
    orderDetails += 'Date: ${timestamp.toIso8601String()}\n';
    orderDetails += 'Items:\n';

    items.forEach((vegetableID, quantity) {
      orderDetails += '  - $vegetableID: $quantity kg\n';
    });

    orderDetails += 'Total Amount: \$${totalAmount.toStringAsFixed(2)}\n';
    return orderDetails;
  }
}

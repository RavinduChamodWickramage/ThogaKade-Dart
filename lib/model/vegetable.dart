class Vegetable {
  final String id;
  final String name;
  final double pricePerKg;
  double availableQuantity;
  final String category;
  final DateTime expiryDate;

  Vegetable({
    required this.id,
    required this.name,
    required this.pricePerKg,
    required this.availableQuantity,
    required this.category,
    required this.expiryDate,
  });

  bool isExpired() {
    return expiryDate.isBefore(DateTime.now());
  }

  void updateStock(double quantity) {
    availableQuantity += quantity;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'pricePerKg': pricePerKg,
      'availableQuantity': availableQuantity,
      'category': category,
      'expiryDate': expiryDate.toIso8601String(),
    };
  }

  factory Vegetable.fromMap(Map<String, dynamic> map) {
    return Vegetable(
      id: map['id'],
      name: map['name'],
      pricePerKg: map['pricePerKg'],
      availableQuantity: map['availableQuantity'],
      category: map['category'],
      expiryDate: DateTime.parse(map['expiryDate']),
    );
  }

  @override
  String toString() {
    return 'Vegetable: $name (ID: $id)\n'
        'Category: $category\n'
        'Price: \$${pricePerKg.toStringAsFixed(2)} per kg\n'
        'Available Quantity: ${availableQuantity.toStringAsFixed(2)} kg\n'
        'Expiry Date: ${expiryDate.toLocal().toString().split(' ')[0]}';
  }
}

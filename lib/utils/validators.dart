class Validators {

  static bool isValidPositiveNumber(String input) {
    final number = double.tryParse(input);
    return number != null && number > 0;
  }


  static bool isValidName(String name) {
    return name.isNotEmpty && name.length >= 3;
  }


  static bool isValidExpiryDate(DateTime expiryDate) {
    return expiryDate.isAfter(DateTime.now());
  }


  static bool isValidVegetableId(String id) {
    return id.isNotEmpty && RegExp(r'^[0-9]+$').hasMatch(id);
  }


  static bool isValidOrderQuantity(double quantity) {
    return quantity > 0;
  }


  static bool isValidTotalAmount(double totalAmount) {
    return totalAmount > 0;
  }


  static bool areValidOrderItems(Map<String, double> items) {
    return items.isNotEmpty && items.values.every((quantity) => quantity > 0);
  }


  static bool isValidPricePerKg(double price) {
    return price > 0;
  }


  static bool isValidId(String id) {
    return RegExp(r'^[0-9]+$').hasMatch(id);
  }
}

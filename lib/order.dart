class Order {
  String? item;
  String? itemName;
  double? price;
  String? currency;
  int? quantity;

  Order({this.item, this.itemName, this.price, this.currency, this.quantity});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      item: json['Item'],
      itemName: json['ItemName'],
      price: json['Price'],
      currency: json['Currency'],
      quantity: json['Quantity'],
    );
  }
}

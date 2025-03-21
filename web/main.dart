import 'dart:convert';
import 'dart:html';
import 'package:exam_flutter/order.dart';

List<Order> orders = [];

void main() {
  loadOrders();
  querySelector('#addButton')?.onClick.listen((event) => addOrder());
  querySelector('#searchInput')?.onInput.listen((event) => searchOrder());
}

void loadOrders() {
  String jsonData = '''
  [
    {"Item": "A1000", "ItemName": "Iphone 15", "Price": 1200, "Currency": "USD", "Quantity": 1},
    {"Item": "A1001", "ItemName": "Iphone 16", "Price": 1500, "Currency": "USD", "Quantity": 1}
  ]
  ''';

  orders = (json.decode(jsonData) as List)
      .map((data) => Order.fromJson(data as Map<String, dynamic>))
      .toList();

  updateOrderList(orders);
}

void updateOrderList(List<Order> orders) {
  TableElement table = querySelector('#orderList tbody') as TableElement;
  table.children.clear();

  for (var order in orders) {
    table.children.add(
      TableRowElement()
        ..children.addAll([
          TableCellElement()..text = order.item,
          TableCellElement()..text = order.itemName,
          TableCellElement()..text = order.quantity.toString(),
          TableCellElement()..text = order.price.toString(),
          TableCellElement()..text = order.currency,
          TableCellElement()
            ..append(ButtonElement()
              ..text = "Delete"
              ..classes.add("btn btn-danger btn-sm")
              ..onClick.listen((_) => deleteOrder(order.item ?? ""))
            )
        ]),
    );
  }
}

void addOrder() {
  InputElement itemInput = querySelector('#itemInput') as InputElement;
  InputElement itemNameInput = querySelector('#itemNameInput') as InputElement;
  InputElement priceInput = querySelector('#priceInput') as InputElement;
  InputElement currencyInput = querySelector('#currencyInput') as InputElement;
  InputElement quantityInput = querySelector('#quantityInput') as InputElement;

  // Kiểm tra dữ liệu nhập vào
  if (itemInput.value!.isEmpty ||
      itemNameInput.value!.isEmpty ||
      priceInput.value!.isEmpty ||
      currencyInput.value!.isEmpty ||
      quantityInput.value!.isEmpty) {
    window.alert("Vui lòng điền đầy đủ thông tin!");
    return;
  }

  double? price = double.tryParse(priceInput.value!);
  int? quantity = int.tryParse(quantityInput.value!);

  if (price == null || quantity == null) {
    window.alert("Giá và số lượng phải là số hợp lệ!");
    return;
  }

  Order newOrder = Order(
    item: itemInput.value!,
    itemName: itemNameInput.value!,
    price: price,
    currency: currencyInput.value!,
    quantity: quantity,
  );

  orders.add(newOrder);
  updateOrderList(orders);

  // Xóa nội dung trong các input sau khi thêm
  itemInput.value = "";
  itemNameInput.value = "";
  priceInput.value = "";
  currencyInput.value = "";
  quantityInput.value = "";
}

void searchOrder() {
  InputElement searchInput = querySelector('#searchInput') as InputElement;
  String searchQuery = searchInput.value?.trim().toLowerCase() ?? "";

  List<Order> filteredOrders = orders.where(
        (order) => order.itemName!.toLowerCase().contains(searchQuery),
  ).toList();

  updateOrderList(filteredOrders);
}

void deleteOrder(String itemId) {
  orders.removeWhere((order) => order.item == itemId);
  updateOrderList(orders);
}

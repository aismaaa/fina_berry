import 'cart_item.dart';

enum OrderStatus { pending, processing, completed, cancelled }

class OrderModel {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime date;
  OrderStatus status;
  final String customerName;
  final String tableNumber;
  final String paymentMethod;

  OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.date,
    this.status = OrderStatus.pending,
    required this.customerName,
    required this.tableNumber,
    required this.paymentMethod,
  });
}

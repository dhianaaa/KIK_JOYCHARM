import '../models/order_model.dart';

class OrderService {
  static final OrderService _instance =
      OrderService._internal();

  factory OrderService() => _instance;

  OrderService._internal();

  final List<OrderModel> orders = [];

  void addOrder(OrderModel order) {
    orders.add(order);
  }
}
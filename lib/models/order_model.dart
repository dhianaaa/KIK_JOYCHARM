import 'product_model.dart';

class OrderModel {
  final Map<ProductModel, int> products;
  final int total;
  final String status;

  OrderModel({
    required this.products,
    required this.total,
    required this.status,
  });
}
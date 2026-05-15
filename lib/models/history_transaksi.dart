class ItemTransaksi {
  int? productId;
  String? productName;
  int? qty;
  int? price;

  ItemTransaksi({
    this.productId,
    this.productName,
    this.qty,
    this.price,
  });

  factory ItemTransaksi.fromJson(Map<String, dynamic> json) {
    return ItemTransaksi(
      productId: json['product_id'],
      productName: json['product_name'],
      qty: json['qty'],
      price: json['price'],
    );
  }
}

class HistoryTransaksi {
  String? transactionId;
  String? date;
  String? status;
  int? total;
  List<ItemTransaksi>? items;

  HistoryTransaksi({
    this.transactionId,
    this.date,
    this.status,
    this.total,
    this.items,
  });

  factory HistoryTransaksi.fromJson(Map<String, dynamic> json) {
    return HistoryTransaksi(
      transactionId: json['transaction_id'],
      date: json['date'],
      status: json['status'],
      total: json['total'],
      items: json['items'] != null
          ? (json['items'] as List)
              .map((e) => ItemTransaksi.fromJson(e))
              .toList()
          : [],
    );
  }
}
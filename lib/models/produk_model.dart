class ProdukModel {
  final int id;
  final String name;
  final String category;
  final String description;
  final int price;
  final double rating;
  final int sold;
  final int stock;
  final String image;

  ProdukModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.rating,
    required this.sold,
    required this.stock,
    required this.image,
  });

  factory ProdukModel.fromJson(Map<String, dynamic> json) {
    return ProdukModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      price: json['price'],
      rating: (json['rating'] as num).toDouble(),
      sold: json['sold'],
      stock: json['stock'],
      image: json['image'],
    );
  }
}
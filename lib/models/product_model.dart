class ProductModel {
  int? id;
  String? name;
  String? category;
  String? description;
  double? price;
  double? rating;
  int? sold;
  int? stock;
  String? image;

  ProductModel({
    this.id,
    this.name,
    this.category,
    this.description,
    this.price,
    this.rating,
    this.sold,
    this.stock,
    this.image,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    description = json['description'];
    price = (json['price'] as num).toDouble();
    rating = (json['rating'] as num).toDouble();
    sold = json['sold'];
    stock = json['stock'];
    image = json['image']; // sudah full URL dari API
  }
}
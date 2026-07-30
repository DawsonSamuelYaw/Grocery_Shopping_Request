class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.category,
    required this.imageUrl,
    required this.description,
    this.discount,
    this.rating = 4.8,
    this.reviewCount = 212,
  });

  final String id;
  final String name;
  final double price;
  final String unit;
  final String category;
  final String imageUrl;
  final String description;
  final int? discount;
  final double rating;
  final int reviewCount;
}

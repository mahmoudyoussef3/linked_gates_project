class ProductEntity {
  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.description,
  });

  final int id;
  final String title;
  final double price;
  final String imageUrl;
  final String? description;
}

import 'cart_size.dart';

class CartItemEntity {
  const CartItemEntity({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
    required this.size,
  });

  final int productId;
  final String title;
  final String imageUrl;
  final double unitPrice;
  final int quantity;
  final CartSize size;

  double get totalPrice => unitPrice * quantity;

  CartItemEntity copyWith({
    int? productId,
    String? title,
    String? imageUrl,
    double? unitPrice,
    int? quantity,
    CartSize? size,
  }) {
    return CartItemEntity(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
    );
  }
}

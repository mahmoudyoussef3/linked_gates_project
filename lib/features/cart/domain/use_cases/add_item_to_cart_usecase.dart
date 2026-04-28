import '../../../products/domain/entities/product_entity.dart';
import '../entities/cart_item_entity.dart';
import '../entities/cart_size.dart';
import '../repositories/cart_repository.dart';

class AddItemToCartUseCase {
  AddItemToCartUseCase(this._repository);

  final CartRepository _repository;

  void call({
    required ProductEntity product,
    required double price,
    required CartSize size,
    int quantity = 1,
  }) {
    _repository.addItem(
      CartItemEntity(
        productId: product.id,
        title: product.title,
        imageUrl: product.imageUrl,
        unitPrice: price,
        quantity: quantity,
        size: size,
      ),
    );
  }
}

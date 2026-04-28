import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartItemsUseCase {
  GetCartItemsUseCase(this._repository);

  final CartRepository _repository;

  List<CartItemEntity> call() => _repository.getItems();
}

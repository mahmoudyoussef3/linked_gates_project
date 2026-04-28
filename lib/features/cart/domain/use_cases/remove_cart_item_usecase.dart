import '../entities/cart_size.dart';
import '../repositories/cart_repository.dart';

class RemoveCartItemUseCase {
  RemoveCartItemUseCase(this._repository);

  final CartRepository _repository;

  void call(int productId, CartSize size) => _repository.remove(productId, size);
}

import '../entities/cart_size.dart';
import '../repositories/cart_repository.dart';

class ManageCartItemQuantityUseCase {
  ManageCartItemQuantityUseCase(this._repository);

  final CartRepository _repository;

  int quantityFor(int productId, CartSize size) =>
      _repository.quantityFor(productId, size);

  void increase(int productId, CartSize size) =>
      _repository.increase(productId, size);

  void decrease(int productId, CartSize size) =>
      _repository.decrease(productId, size);
}

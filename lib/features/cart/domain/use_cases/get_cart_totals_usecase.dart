import '../repositories/cart_repository.dart';

class GetCartTotalsUseCase {
  GetCartTotalsUseCase(this._repository);

  final CartRepository _repository;

  int totalItems() => _repository.getTotalItems();
  double totalPrice() => _repository.getTotalPrice();
}

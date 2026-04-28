import '../repositories/cart_repository.dart';

class ClearCartUseCase {
  ClearCartUseCase(this._repository);

  final CartRepository _repository;

  void call() => _repository.clear();
}

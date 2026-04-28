import '../../domain/entities/cart_item_entity.dart';
import '../../domain/entities/cart_size.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final Map<String, CartItemEntity> _items = {};

  @override
  List<CartItemEntity> getItems() => _items.values.toList(growable: false);

  @override
  int getTotalItems() =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  @override
  double getTotalPrice() =>
      _items.values.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  int quantityFor(int productId, CartSize size) =>
      _items[_key(productId, size)]?.quantity ?? 0;

  @override
  void addItem(CartItemEntity item) {
    final key = _key(item.productId, item.size);
    final existing = _items[key];
    if (existing != null) {
      _items[key] = existing.copyWith(quantity: existing.quantity + item.quantity);
      return;
    }
    _items[key] = item;
  }

  @override
  void increase(int productId, CartSize size) {
    final key = _key(productId, size);
    final existing = _items[key];
    if (existing == null) return;
    _items[key] = existing.copyWith(quantity: existing.quantity + 1);
  }

  @override
  void decrease(int productId, CartSize size) {
    final key = _key(productId, size);
    final existing = _items[key];
    if (existing == null) return;
    if (existing.quantity <= 1) {
      _items.remove(key);
      return;
    }
    _items[key] = existing.copyWith(quantity: existing.quantity - 1);
  }

  @override
  void remove(int productId, CartSize size) {
    _items.remove(_key(productId, size));
  }

  @override
  void clear() {
    _items.clear();
  }

  String _key(int productId, CartSize size) => '${productId}_${size.name}';
}

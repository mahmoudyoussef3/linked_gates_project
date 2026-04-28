import '../entities/cart_item_entity.dart';
import '../entities/cart_size.dart';

abstract class CartRepository {
  List<CartItemEntity> getItems();
  int getTotalItems();
  double getTotalPrice();
  int quantityFor(int productId, CartSize size);
  void addItem(CartItemEntity item);
  void increase(int productId, CartSize size);
  void decrease(int productId, CartSize size);
  void remove(int productId, CartSize size);
  void clear();
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linked_gates_project/features/cart/presentation/provider/cart_provider.dart';
import 'package:linked_gates_project/features/cart/presentation/widgets/cart_item_tile.dart';

class CartItemsList extends StatelessWidget {
  const CartItemsList({super.key, required this.cart});
  final CartProvider cart ;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: cart.items.length,
        separatorBuilder: (_, _) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final item = cart.items[index];
          return CartItemTile(item: item);
        },
      ),
    );
  }
}

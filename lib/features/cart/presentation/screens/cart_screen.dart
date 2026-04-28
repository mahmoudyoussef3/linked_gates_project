import 'package:flutter/material.dart';

import 'package:linked_gates_project/features/cart/presentation/widgets/cart_items_list.dart';
import 'package:linked_gates_project/features/cart/presentation/widgets/total_section.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/app_message_view.dart';
import '../provider/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return const AppMessageView(
              message: 'Your cart is empty.',
              icon: Icons.shopping_bag_outlined,
            );
          }

          return Column(
            children: [
              CartItemsList(cart: cart),
              TotalSection(cart: cart),
            ],
          );
        },
      ),
    );
  }
}

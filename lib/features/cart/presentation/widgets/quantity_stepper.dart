import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linked_gates_project/core/styles/app_text_styles.dart';
import 'package:linked_gates_project/features/cart/domain/entities/cart_item_entity.dart';
import 'package:linked_gates_project/features/cart/presentation/provider/cart_provider.dart';
import 'package:linked_gates_project/features/cart/presentation/widgets/stepper_button.dart';
import 'package:provider/provider.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({super.key, required this.item});

  final CartItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StepperButton(
          icon: Icons.add,
          onTap: () =>
              context.read<CartProvider>().increase(item.productId, item.size),
        ),
        SizedBox(height: 8.h),
        Text(item.quantity.toString(), style: AppTextStyles.title),
        SizedBox(height: 8.h),
        StepperButton(
          icon: Icons.remove,
          onTap: () {
            if (item.quantity > 1) {
              context.read<CartProvider>().decrease(item.productId, item.size);
            } else {
              context.read<CartProvider>().remove(item.productId, item.size);
            }
          },
        ),
      ],
    );
  }
}
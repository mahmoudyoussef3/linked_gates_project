import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linked_gates_project/core/styles/app_colors.dart';
import 'package:linked_gates_project/core/styles/app_text_styles.dart';
import 'package:linked_gates_project/core/widgets/functions.dart';
import 'package:linked_gates_project/features/cart/presentation/provider/cart_provider.dart';

class TotalSection extends StatelessWidget {
  const TotalSection({super.key, required this.cart});
  final CartProvider cart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text('Total', style: AppTextStyles.subtitle),
          const Spacer(),
          Text(cart.formattedTotalPrice, style: AppTextStyles.priceLarge),
          SizedBox(width: 12.w),
          ElevatedButton(
            onPressed: () {
              showToast(message: 'Checkout is not implemented yet.');
            },
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }
}

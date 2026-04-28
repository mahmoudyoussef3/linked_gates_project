import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:linked_gates_project/core/extensions/price_extensions.dart';
import 'package:linked_gates_project/core/styles/app_text_styles.dart';
import 'package:linked_gates_project/features/cart/domain/entities/cart_item_entity.dart';
import 'package:linked_gates_project/features/cart/presentation/widgets/size_chip.dart';

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key, required this.item});

  final CartItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.title,
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Text(item.unitPrice.formatCurrency(), style: AppTextStyles.price),
            SizedBox(width: 8.w),
            SizeChip(size: item.size.name.toUpperCase()),
          ],
        ),
        SizedBox(height: 6.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: 'Total: ', style: AppTextStyles.caption),
              TextSpan(
                text: item.totalPrice.formatCurrency(),
                style: AppTextStyles.price,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/styles/app_text_styles.dart';

class ProductListAppBarTitle extends StatelessWidget {
  const ProductListAppBarTitle({super.key, required this.productsCount});

  final int productsCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Linked Gates', style: AppTextStyles.titleLarge),
        SizedBox(height: 4.h),
        Text(
          '$productsCount products available',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}
